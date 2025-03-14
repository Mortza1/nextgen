import paho.mqtt.client as mqtt
import redis  # Using Redis as the message queue (can replace with Kafka, RabbitMQ)
import requests  # HTTP requests to main backend for updates
import time  # To add a simple blocking wait

# Configure MQTT
MQTT_BROKER = "localhost"
MQTT_PORT = 1883
MQTT_TOPIC = "devices/+/state"  # Adjust topic to match your devices' topics

# Configure Redis (or another event bus like Kafka, RabbitMQ)
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
pubsub = redis_client.pubsub()

# Function to send data to the main backend via HTTP
def send_to_backend(device_id, new_state):
    url = "https://5a22-2-51-16-105.ngrok-free.app/device_update"
    payload = {
        "device_id": device_id,
        "new_state": new_state
    }
    response = requests.post(url, json=payload)
    

# MQTT Callback when a message is received
def on_message(client, userdata, msg):
    device_id = msg.topic.split("/")[1]  # Extract device ID from topic
    new_state = msg.payload.decode()  # State value sent by device

    # Publish the state change to Redis (or Kafka/RabbitMQ)
    redis_client.publish("device_updates", f"{device_id}:{new_state}")

    # Optionally, send the state change directly to the backend via HTTP request
    send_to_backend(device_id, new_state)

# Setup MQTT Client
mqtt_client = mqtt.Client()
mqtt_client.on_message = on_message
mqtt_client.connect(MQTT_BROKER, MQTT_PORT, 60)
mqtt_client.subscribe(MQTT_TOPIC)

mqtt_client.loop_start()  # Start listening to MQTT broker

# Block the script from exiting (keep it running indefinitely)
try:
    while True:
        time.sleep(1)  # Keep the script running
except KeyboardInterrupt:
    print("Script stopped manually.")
