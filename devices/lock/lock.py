import paho.mqtt.client as mqtt
import time
import json
import os
from dotenv import load_dotenv
from datetime import datetime
import getpass
import threading

# Load environment variables
load_dotenv()

# MQTT Configuration
MQTT_BROKER = os.getenv("MQTT_BROKER", "localhost")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
DEVICE_ID = os.getenv("DEVICE_ID", "lock_default")
COMMAND_TOPIC = f"devices/{DEVICE_ID}/command"
STATE_TOPIC = f"devices/{DEVICE_ID}/state"  # Topic to publish state updates

# File to store the password
PASSWORD_FILE = "password.txt"
AUTO_LOCK_TIME = 5  # Auto-lock after 5 seconds

# Function to get or set the password
def get_or_set_password():
    if os.path.exists(PASSWORD_FILE):
        with open(PASSWORD_FILE, "r") as file:
            return file.read().strip()
    else:
        password = getpass.getpass("🔑 Set up a new password for the lock: ")
        with open(PASSWORD_FILE, "w") as file:
            file.write(password)
        print("✅ Password set successfully!")
        return password

# Load the password
lock_password = get_or_set_password()

# Lock State
lock_state = {
    "is_locked": True,  # Initially locked
    "last_access": None,
    "is_on" : True
}

# MQTT Callbacks
def on_connect(client, userdata, flags, rc):
    print(f"🔗 Connected to MQTT Broker with result code {rc}")
    client.subscribe(COMMAND_TOPIC)

def on_message(client, userdata, msg):
    payload_str = msg.payload.decode().strip()
    if not payload_str:
        print(f"⚠️ Received an empty message on {msg.topic}, ignoring.")
        return

    try:
        payload = json.loads(payload_str)
    except json.JSONDecodeError as e:
        print(f"⚠️ JSON decode error: {e}. Payload received: {payload_str}")
        return
    
    command = payload.get("command")

    if command == "plug_in":
        lock_state["is_on"] = True
        print('lock is on')
        publish_state()    

    elif command == "unplug":
        lock_state["is_on"] = True
        print('lock is off')
        publish_state()
    
    elif command == "unlock":
        if lock_state["is_on"] and lock_state["is_locked"]:
            lock_state["is_locked"] = False
            lock_state["last_access"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print("✅ Access granted! Lock is now OPEN.")
            publish_state()
    else:
        print(f"Unknown command: {command}")
    

    # process_unlock(payload.get("password", ""))

# Function to process unlock attempt
def process_unlock(password_attempt):
    global lock_state

    if password_attempt == lock_password:
        lock_state["is_locked"] = False
        lock_state["last_access"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print("✅ Access granted! Lock is now OPEN.")

        # Start auto-lock timer
        threading.Timer(AUTO_LOCK_TIME, auto_lock).start()
    else:
        print("❌ Access denied! Incorrect password.")

    publish_state()  # Publish lock state

# Function to auto-lock after a delay
def auto_lock():
    global lock_state
    lock_state["is_locked"] = True
    print("🔒 Auto-lock activated! Lock is now CLOSED.")
    publish_state()

# Function to publish lock state
def publish_state():
    state_entry = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "is_locked": lock_state["is_locked"],
        "last_access": lock_state["last_access"],
        "is_on": lock_state["is_on"]
    }

    client.publish(STATE_TOPIC, json.dumps(state_entry))
    print(f"📡 Published state: {state_entry}")

# Initialize MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

# Run terminal-based password input
while True:
    if lock_state["is_locked"]:
        user_password = getpass.getpass("\n🔑 Enter password to unlock: ")
        process_unlock(user_password)
    
    time.sleep(1)  # Prevents unnecessary CPU usage
