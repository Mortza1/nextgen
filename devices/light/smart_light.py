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
DEVICE_ID = os.getenv("DEVICE_ID", "smart_light_default")
DEVICE_TOPIC = f"devices/{DEVICE_ID}/command"

# Smart Light State
light_state = {
    "is_on": False,
    "rgb": (255, 255, 255),  # Default White
    "brightness": 100,  # Default 100%
    "power_consumption": 0.0,  # Power in watts
    "last_on_time": None,  # Time when light was turned on
    "total_energy": 0.0  # Total energy consumed (Wh)
}

POWER_CONSUMPTION_RATE = 0.1  # Watts per second at 100% brightness

# Log file path
LOG_FILE = "smart_light_log.txt"

# MQTT Callbacks
def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(DEVICE_TOPIC)


def on_message(client, userdata, msg):
    global light_state
    
    payload_str = msg.payload.decode().strip()  # Decode and remove leading/trailing spaces
    
    if not payload_str:  # Check for empty payload
        print(f"Received an empty message on {msg.topic}, ignoring.")
        return

    try:
        payload = json.loads(payload_str)  # Parse JSON safely
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
        print(f"{DEVICE_ID} RGB set to {light_state['rgb']}")

    elif command == "set_brightness":
        light_state["brightness"] = max(0, min(100, payload.get("brightness", 100)))
        print(f"{DEVICE_ID} Brightness set to {light_state['brightness']}%")

    else:
        print(f"Unknown command: {command}")


# Initialize MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

# Function to log state
def log_light_state():
    global light_state

    if light_state["is_on"]:
        elapsed_time = time.time() - light_state["last_on_time"]
        power_usage = (POWER_CONSUMPTION_RATE * light_state["brightness"] / 100) * elapsed_time / 3600  # Convert to Wh
        light_state["total_energy"] += power_usage
        light_state["power_consumption"] = power_usage
        light_state["last_on_time"] = time.time()  # Reset last on time

    log_entry = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "is_on": light_state["is_on"],
        "rgb": light_state["rgb"],
        "brightness": light_state["brightness"],
        "power_consumption": round(light_state["power_consumption"], 4),
        "total_energy": round(light_state["total_energy"], 4)
    }

    with open(LOG_FILE, "a") as log_file:
        log_file.write(json.dumps(log_entry) + "\n")

    print(f"Logged state: {log_entry}")

# Simulate device running with adaptive logging interval
while True:
    log_light_state()
    interval = 3 if light_state["is_on"] else 10  # 3 sec when on, 10 sec when off
    time.sleep(interval)
