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
DEVICE_ID = os.getenv("DEVICE_ID", "smart_thermostat_default")
COMMAND_TOPIC = f"devices/{DEVICE_ID}/command"
STATE_TOPIC = f"devices/{DEVICE_ID}/state"  # Topic to publish state updates

# Thermostat State
thermostat_state = {
    "is_on" : True, 
    "current_temperature": 29.0,  # Initial temperature
    "target_temperature": 22.0,  # Default target temperature
    "fan_speed": 1,  # Fan speed: 1 (low), 2 (medium), 3 (high)
    "heating": False,  # Whether heating is on
    "cooling": False,  # Whether cooling is on
    "power_consumption": 0.0,  # Power in watts
}

# Simulation Parameters
TEMP_CHANGE_RATE = 0.5  # Degrees per 10 seconds at fan speed 1
FAN_SPEED_MULTIPLIER = {1: 1.0, 2: 1.5, 3: 2.0}  # Higher fan speeds adjust temp faster
POWER_USAGE = {1: 500, 2: 750, 3: 1000}  # Watts based on fan speed
HEATER_POWER = 1500  # Watts when heating
COOLER_POWER = 1200  # Watts when cooling
UPDATE_TIME = 100  # Update every 10 seconds

def energy_calculator(usage, time):
    return round((usage / 3600) * time)

# MQTT Callbacks
def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(COMMAND_TOPIC)

def on_message(client, userdata, msg):
    global thermostat_state
    
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
        thermostat_state["is_on"] = True
        print("Thermostat is now on")

    elif command == "plug_out":
        thermostat_state["is_on"] = False
        print("Thermostat is now off")
    
    elif command == "increase_temp":
        increment = payload.get("value", 1)  # Default increase by 1°C
        thermostat_state["target_temperature"] += increment
        print(f"Target temperature increased to {thermostat_state['target_temperature']}°C")

    elif command == "decrease_temp":
        decrement = payload.get("value", 1)  # Default decrease by 1°C
        thermostat_state["target_temperature"] -= decrement
        print(f"Target temperature decreased to {thermostat_state['target_temperature']}°C")

    elif command == "set_fan_speed":
        fan_speed = max(1, min(3, payload.get("value", 1)))  # Clamp value between 1-3
        thermostat_state["fan_speed"] = fan_speed
        print(f"Fan speed set to {fan_speed}")

    else:
        print(f"Unknown command: {command}")

    publish_state()  # Publish state after any command update

# Function to update temperature gradually
def update_temperature():
    global thermostat_state

    if thermostat_state["is_on"]:
        diff = thermostat_state["target_temperature"] - thermostat_state["current_temperature"]
        fan_multiplier = FAN_SPEED_MULTIPLIER[thermostat_state["fan_speed"]]
        
        if abs(diff) > 0.05:  # Prevents micro adjustments
            change = TEMP_CHANGE_RATE * fan_multiplier * (1 if diff > 0 else -1)
            thermostat_state["current_temperature"] += change
            thermostat_state["current_temperature"] = round(thermostat_state["current_temperature"], 2)  # Round for realism

            # Determine heating/cooling state
            thermostat_state["heating"] = diff > 0
            thermostat_state["cooling"] = diff < 0

            # Simulate power consumption
            total_consumption = 0
            fan_consumtion = energy_calculator(POWER_USAGE[thermostat_state["fan_speed"]], UPDATE_TIME) if diff != 0 else 0
            if thermostat_state['heating']:
                total_consumption = energy_calculator(HEATER_POWER, UPDATE_TIME) + fan_consumtion
            elif thermostat_state['cooling']:
                total_consumption = energy_calculator(COOLER_POWER, UPDATE_TIME) + fan_consumtion
            else:
                total_consumption = fan_consumtion
            
            thermostat_state["power_consumption"] += total_consumption

# Function to publish thermostat state
def publish_state():
    state_entry = {
        "device_id" : DEVICE_ID,
        "device_type": 'thermostat',
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "metric": {
            "is_on": thermostat_state["is_on"],
            "current_temperature": thermostat_state["current_temperature"],
            "target_temperature": thermostat_state["target_temperature"],
            "fan_speed": thermostat_state["fan_speed"],
            "heating": thermostat_state["heating"],
            "cooling": thermostat_state["cooling"],
            "power_consumption": thermostat_state["power_consumption"],
        },
    }

    client.publish(STATE_TOPIC, json.dumps(state_entry))

# Initialize MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

# Run temperature update loop
while True:
    update_temperature()
    publish_state()

    time.sleep(UPDATE_TIME)  # Updates every 10 second to simulate real-time changes
