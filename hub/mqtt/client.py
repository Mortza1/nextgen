import asyncio
import json
import paho.mqtt.client as mqtt
import threading

mqtt_client = mqtt.Client()

# MQTT callbacks
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker successfully!")
    else:
        print(f"Failed to connect, return code {rc}")
        print(f"Connection details: {client._userdata}")


def on_message(client, userdata, msg):
    print(f"Received message on {msg.topic}: {msg.payload.decode()}")

# Function to start the MQTT client
async def start_mqtt_client():
    mqtt_client.on_connect = on_connect
    mqtt_client.on_message = on_message
    mqtt_client.connect("127.0.0.1", 1883, 60)  # Use the correct MQTT broker address

    # Start MQTT loop in a separate background thread to avoid blocking FastAPI
    def mqtt_loop():
        # This runs in the background and keeps MQTT handling in a non-blocking way
        mqtt_client.loop_forever()

    # Start MQTT loop in a new thread
    thread = threading.Thread(target=mqtt_loop, daemon=True)
    thread.start()

    # Ensure FastAPI doesn't exit before MQTT client is ready
    await asyncio.sleep(1)  # Add some time for MQTT to connect and stabilize

async def stop_mqtt_client():
    # Disconnect MQTT client when FastAPI shuts down
    mqtt_client.disconnect()
    print("Disconnected from MQTT broker")

# Function to publish messages to a specific topic
def publish_message(topic, message):
    result = mqtt_client.publish(topic, json.dumps({"command": message}))
    if result.rc == mqtt.MQTT_ERR_SUCCESS:
        print(f"Message '{message}' successfully published to topic '{topic}'")
    else:
        print(f"Failed to publish message '{message}' to topic '{topic}'")

