import paho.mqtt.client as mqtt
import time
import json
import os
import base64
import cv2
import numpy as np
from dotenv import load_dotenv
from datetime import datetime

# Load environment variables
load_dotenv()

# MQTT Configuration
MQTT_BROKER = os.getenv("MQTT_BROKER", "localhost")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
DEVICE_ID = os.getenv("DEVICE_ID", "camera_device_default")
FRAME_TOPIC = f"devices/{DEVICE_ID}/frames"
STATE_TOPIC = f"devices/{DEVICE_ID}/state"
COMMAND_TOPIC = f"devices/{DEVICE_ID}/command"  # Add command topic

# Camera Simulation Constants
FRAME_RATE = 60  # Frames per second
FRAME_BATCH = 120  # Number of frames per batch
RESOLUTION = (640, 480)  # Simulated resolution

# Power Consumption (in Watts)
POWER_USAGE = {
    "normal": 5,
    "night_vision": 7,
    "motion_detection": 6,
    "off": 0, #add off mode
}

# Initial State
camera_state = {
    "mode": "normal",
    "power_consumption": 0.0,
    "last_transmission": None,
    "plugged_in": True, # add plugged in state
}

# Try to open the webcam
camera_capture = cv2.VideoCapture(0)

if not camera_capture.isOpened():
    print("Webcam not found, switching to dummy frame generation.")
    camera_capture = None  # Simulate the webcam being unavailable

def generate_dummy_frame():
    """Simulate a video frame and return both raw and encoded versions."""
    frame = np.random.randint(0, 256, (RESOLUTION[1], RESOLUTION[0], 3), dtype=np.uint8)
    success, buffer = cv2.imencode('.jpg', frame)
    if not success:
        print("Error encoding frame, returning empty frame")
        return frame, ""
    encoded_frame = base64.b64encode(buffer).decode('utf-8')
    return frame, encoded_frame


def compress_frame(frame_data):
    """Stub function for compression (to be implemented)."""
    return frame_data  # Currently, just passing through

def calculate_power_usage(mode, duration):
    """Calculate power consumption based on mode and duration (in seconds)."""
    return round((POWER_USAGE[mode] / 3600) * duration, 4)

def publish_frames():
    global camera_state

    if not camera_state["plugged_in"]:
        print("Camera is unplugged, not publishing frames.")
        return

    frames = []
    for _ in range(FRAME_BATCH):
        if camera_capture:
            ret, raw_frame = camera_capture.read()
            if not ret:
                print("Failed to capture frame from webcam, using dummy frame.")
                raw_frame, encoded_frame = generate_dummy_frame()
            else:
                _, buffer = cv2.imencode('.jpg', raw_frame)
                encoded_frame = base64.b64encode(buffer).decode('utf-8')
        else:
            raw_frame, encoded_frame = generate_dummy_frame()
        
        if not encoded_frame:  # Handle empty frame
            print("Skipping empty frame.")
            continue  # Skip adding to frames list

        frames.append(compress_frame(encoded_frame))  # Send encoded frame

        cv2.imshow("Camera Feed", raw_frame)
        if cv2.waitKey(10) & 0xFF == ord('q'):
            cv2.destroyAllWindows()
            exit()

    payload = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "frames": frames,
    }
    client.publish(FRAME_TOPIC, json.dumps(payload))

    camera_state["last_transmission"] = payload["timestamp"]
    camera_state["power_consumption"] += calculate_power_usage(camera_state["mode"], FRAME_BATCH / FRAME_RATE)
    publish_state()


def publish_state():
    """Publish camera state."""
    print(f"Publishing state: {camera_state}")
    client.publish(STATE_TOPIC, json.dumps(camera_state))

def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT Broker with result code {rc}")
    client.subscribe(COMMAND_TOPIC) #add subscribe to command topic

def on_message(client, userdata, msg):
    global camera_state
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
        camera_state["plugged_in"] = True
        print(f"{DEVICE_ID} plugged in")
        publish_state()
    elif command == "plug_out":
        camera_state["plugged_in"] = False
        print(f"{DEVICE_ID} plugged out")
        publish_state()
    elif "mode" in payload and payload["mode"] in POWER_USAGE:
        camera_state["mode"] = payload["mode"]
        print(f"Camera mode set to {camera_state['mode']}")
        publish_state()
    else:
        print(f"Unknown command: {command}")

# Initialize MQTT client
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

# Main loop
while True:
    if camera_state["plugged_in"]: #only send frames if plugged in.
        publish_frames()
    time.sleep(FRAME_BATCH / FRAME_RATE)  # Simulate real-time frame capture