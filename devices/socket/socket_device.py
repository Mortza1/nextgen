import paho.mqtt.client as mqtt
import time
import json
import os
from dotenv import load_dotenv
from datetime import datetime

# Load environment variables
load_dotenv()

# MQTT Configuration
MQTT_BROKER = os.getenv("MQTT_BROKER", "localhost")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
DEVICE_ID = os.getenv("DEVICE_ID", "smart_socket_default")
COMMAND_TOPIC = f"devices/{DEVICE_ID}/command"
STATE_TOPIC = f"devices/{DEVICE_ID}/state"  # Topic to publish state updates

# Smart Socket State
socket_state = {
    "is_plugged_in": True,
    "up_time" : 0.0,
    "total_consumption" : 0.0,
}

power_rate = 200
DELAY = 100

# MQTT Callbacks
def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(COMMAND_TOPIC)

def on_message(client, userdata, msg):
    global socket_state
    
    payload_str = msg.payload.decode().strip()
    if not payload_str:
        print(f"Received an empty message on {msg.topic}, ignoring.")
        return

    try:
        payload = json.loads(payload_str)
    except json.JSONDecodeError as e:
        print(f"JSON decode error: {e}. Payload received: {payload_str}")
        return

    command = payload.get("command")

    if command == "plug_in":
        socket_state["is_plugged_in"] = True
        socket_state['up_time'] = time.time()
        print('socket plugged in')
            

    elif command == "unplug":
        socket_state['up_time'] = 0.0
        socket_state["is_plugged_in"] = False
        print('socket plugged out')
    

    else:
        print(f"Unknown command: {command}")

    publish_state()  # Publish state after any command update

# Function to publish socket state
def publish_state():
    global socket_state

    if socket_state['is_plugged_in']:
        socket_state['total_consumption'] += power_rate * 5 / 3600
        socket_state['up_time'] += DELAY

    state_entry = {
        "device_id": DEVICE_ID,
        "device_type": 'socket',
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "metric": {
            "is_plugged_in": socket_state["is_plugged_in"],
            "power_consumption": round(socket_state["total_consumption"], 2),
            "up_time": socket_state['up_time']
        },
    }

    client.publish(STATE_TOPIC, json.dumps(state_entry))

# Initialize MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

# Run logging and publishing loop
while True:
    if socket_state["is_plugged_in"]:
        publish_state()
    time.sleep(DELAY)  # Update every 5 seconds

