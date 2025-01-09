import paho.mqtt.client as mqtt
import time
import json

# MQTT Configuration
MQTT_BROKER = "localhost"
MQTT_PORT = 1883
DEVICE_ID = "smart_light_1"
DEVICE_TOPIC = f"home/house_1/device/{DEVICE_ID}/command"

# Define callback functions
def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(DEVICE_TOPIC)

def on_message(client, userdata, msg):
    payload = json.loads(msg.payload.decode())
    command = payload.get("command")
    if command == "turn_on":
        print(f"{DEVICE_ID} turned on")
    elif command == "turn_off":
        print(f"{DEVICE_ID} turned off")
    else:
        print(f"Unknown command: {command}")

# Initialize MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# Connect to MQTT broker
client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

# Simulate device running
while True:
    time.sleep(1)
