import asyncio
import json
import os
import paho.mqtt.client as mqtt
import threading
import base64
import cv2
import numpy as np
from datetime import datetime
import glob  # Added for cleaning old files

mqtt_client = mqtt.Client()

DATA_DIR = "device_data"
os.makedirs(DATA_DIR, exist_ok=True)

FRAME_DIR = os.path.join(DATA_DIR, "frames")
os.makedirs(FRAME_DIR, exist_ok=True)

VIDEO_DIR = os.path.join(DATA_DIR, "videos")
os.makedirs(VIDEO_DIR, exist_ok=True)

FRAME_RATE = 60  # Frames per second
FRAME_WIDTH = 640
FRAME_HEIGHT = 480

frame_buffer = {}  # Store frames per device

# MQTT callbacks
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("Connected to MQTT broker successfully!")
        client.subscribe("devices/+/state")
        client.subscribe("devices/+/frames")  # Subscribe to frame topic
    else:
        print(f"Failed to connect, return code {rc}")


def on_message(client, userdata, msg):
    topic = msg.topic
    payload = msg.payload.decode()
    
    if topic.startswith("devices/") and topic.endswith("/state"):
        handle_state_message(topic, payload)
    elif topic.startswith("devices/") and topic.endswith("/frames"):
        handle_frame_message(topic, payload)
    else:
        print(f"Received unknown message on {topic}: {payload}")


def handle_state_message(topic, payload):
    """Handles incoming device state messages and saves them."""
    try:
        state_data = json.loads(payload)
        device_id = topic.split("/")[1]  # Extract device ID
        file_path = os.path.join(DATA_DIR, f"{device_id}.json")

        # Read existing data if file exists
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


def handle_frame_message(topic, payload):
    """Handles incoming frames, saves them as images, and creates a video."""
    try:
        data = json.loads(payload)
        device_id = topic.split("/")[1]  # Extract device ID
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        frames = data.get("frames", [])
        if not frames:
            return
        
        if device_id not in frame_buffer:
            frame_buffer[device_id] = []

        for i, frame_base64 in enumerate(frames):
            frame_data = base64.b64decode(frame_base64)
            frame_np = np.frombuffer(frame_data, dtype=np.uint8)
            frame = cv2.imdecode(frame_np, cv2.IMREAD_COLOR)

            if frame is not None:
                frame_filename = os.path.join(FRAME_DIR, f"{device_id}_{timestamp}_{i}.jpg")
                cv2.imwrite(frame_filename, frame)
                frame_buffer[device_id].append(frame_filename)

        # Convert to video if we have enough frames
        if len(frame_buffer[device_id]) >= FRAME_RATE * 5:  # 5 seconds of frames
            save_video(device_id)
            frame_buffer[device_id] = []  # Clear buffer after saving video

        print(f"Received and saved {len(frames)} frames from {device_id}")

    except json.JSONDecodeError:
        print("Invalid JSON frame data!")


def save_video(device_id):
    """Converts stored images into a video and deletes old frames and previous videos."""
    
    # Remove old videos for the device
    delete_old_videos(device_id)

    frames = sorted(frame_buffer[device_id])  # Sort to maintain correct order
    if not frames:
        return

    video_filename = os.path.join(VIDEO_DIR, f"{device_id}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.mp4")
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # MP4 format
    out = cv2.VideoWriter(video_filename, fourcc, FRAME_RATE, (FRAME_WIDTH, FRAME_HEIGHT))

    for frame_path in frames:
        frame = cv2.imread(frame_path)
        if frame is not None:
            out.write(frame)

    out.release()
    print(f"Video saved: {video_filename}")

    # Delete all frames after video conversion
    delete_old_frames(device_id)


def delete_old_videos(device_id):
    """Deletes all previous videos of the device before saving a new one."""
    old_videos = glob.glob(os.path.join(VIDEO_DIR, f"{device_id}_*.mp4"))
    for video in old_videos:
        try:
            os.remove(video)
            print(f"Deleted old video: {video}")
        except Exception as e:
            print(f"Error deleting video {video}: {e}")


def delete_old_frames(device_id):
    """Deletes all frames after the video is created."""
    old_frames = glob.glob(os.path.join(FRAME_DIR, f"{device_id}_*.jpg"))
    for frame in old_frames:
        try:
            os.remove(frame)
        except Exception as e:
            print(f"Error deleting frame {frame}: {e}")
    print(f"All frames deleted for {device_id}")


# Function to start the MQTT client
async def start_mqtt_client():
    mqtt_client.on_connect = on_connect
    mqtt_client.on_message = on_message
    mqtt_client.connect("127.0.0.1", 1883, 60)  # Use the correct MQTT broker address

    # Start MQTT loop in a separate background thread
    def mqtt_loop():
        mqtt_client.loop_forever()

    thread = threading.Thread(target=mqtt_loop, daemon=True)
    thread.start()

    await asyncio.sleep(1)  # Allow MQTT to stabilize


async def stop_mqtt_client():
    mqtt_client.disconnect()
    print("Disconnected from MQTT broker")


# Function to publish messages
def publish_message(topic, message):
    result = mqtt_client.publish(topic, json.dumps({"command": message}))
    if result.rc == mqtt.MQTT_ERR_SUCCESS:
        print(f"Message '{message}' successfully published to topic '{topic}'")
    else:
        print(f"Failed to publish message '{message}' to topic '{topic}'")
