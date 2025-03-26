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
DEVICE_ID = os.getenv("DEVICE_ID")
COMMAND_TOPIC = f"devices/{DEVICE_ID}/command"
STATE_TOPIC = f"devices/{DEVICE_ID}/state"  # Topic to publish state updates

# Smart Light State
light_state = {
    "is_on": False, 
    "rgb": (255, 255, 255),  # Default White
    "brightness": 100,  # Default 100%
    "power_consumption": 0.0,  # Power in watts
    "last_on_time": None,  # Time when light was turned on
}
DELAY = 10

POWER_CONSUMPTION_RATE = 0.00000417  # Watts per second at 100% brightness

# MQTT Callbacks
def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(COMMAND_TOPIC)

def on_message(client, userdata, msg):
    global light_state
    
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

    if command == "turn_on":
        light_state["is_on"] = True
        light_state["last_on_time"] = time.time()
        print(f"{DEVICE_ID} turned on")

    elif command == "turn_off":
        light_state["is_on"] = False
        light_state["last_on_time"] = None
        print(f"{DEVICE_ID} turned off")

    elif command == "set_rgb":
        light_state["rgb"] = tuple(payload.get("rgb", (255, 255, 255)))
        print(f"{DEVICE_ID} RGB updated")

    elif command == "set_brightness":
        light_state["brightness"] = max(0, min(100, payload.get("brightness", 100)))
        print(f"{DEVICE_ID} Brightness updated")

    else:
        print(f"Unknown command: {command}")

    publish_state()  # Publish state after any command update

# Function to publish light state
def publish_state():
    global light_state

    if light_state["is_on"]:
        power_usage = (POWER_CONSUMPTION_RATE * (light_state["brightness"] / 100)) * DELAY
        light_state["power_consumption"] += power_usage
        light_state["last_on_time"] = time.time()

    state_entry = {
        "device_id": DEVICE_ID,
        "device_type": 'light',
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        'metric': {
            "is_on": light_state["is_on"],
            "rgb": light_state["rgb"],
            "brightness": light_state["brightness"],
            "power_consumption": round(light_state["power_consumption"], 4),
        }
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
    publish_state() if light_state["is_on"] else None 
    time.sleep(DELAY)
