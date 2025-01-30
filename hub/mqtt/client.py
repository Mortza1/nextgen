import asyncio
import json
import os
import paho.mqtt.client as mqtt
import threading

mqtt_client = mqtt.Client()

DATA_DIR = "device_data"
os.makedirs(DATA_DIR, exist_ok=True)

# MQTT callbacks
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker successfully!")
        client.subscribe("devices/+/state")
    else:
        print(f"Failed to connect, return code {rc}")
        print(f"Connection details: {client._userdata}")


def on_message(client, userdata, msg):
    topic = msg.topic
    payload = msg.payload.decode()
    
    # Check if the message is a device state update
    if topic.startswith("devices/") and topic.endswith("/state"):
        print(f"Received device state update: {payload}")

        try:
            state_data = json.loads(payload)  # Convert JSON string to dict
            device_id = topic.split("/")[1]  # Extract device ID from topic
            
            # Define file path for the device
            file_path = os.path.join(DATA_DIR, f"{device_id}.json")

            # Read existing data if the file exists
            if os.path.exists(file_path):
                with open(file_path, "r") as f:
                    try:
                        existing_data = json.load(f)
                    except json.JSONDecodeError:
                        existing_data = []
            else:
                existing_data = []

            # Append new state update
            existing_data.append(state_data)

            # Save updated data
            with open(file_path, "w") as f:
                json.dump(existing_data, f, indent=4)

            print(f"State saved for {device_id}")

        except json.JSONDecodeError:
            print("Invalid JSON received!")
    else:
        print(f"Received unknown message on {topic}: {payload}")

        
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

