## Device Hub Software
This software powers the Device Hub, a local controller designed to manage smart devices within a private network using MQTT and FastAPI. The Hub connects to a main backend server for data synchronization and remote management while ensuring secure and efficient local communication with devices.

# Features
Private MQTT Broker: Handles communication between the Hub and smart devices on the local network.
Device Control APIs: Exposes RESTful APIs for device management, allowing control commands from an external app.
Backend Integration: Connects to a centralized backend for synchronization and remote updates.
Configurable Environment: Utilizes an .env file to store unique configuration parameters for each hub.
Device Command Processing: Uses MQTT for real-time command distribution and status updates.

## Installation and Setup

# Prerequisites
Python 3.8+
Mosquitto MQTT Broker
FastAPI Framework
paho-mqtt Library
httpx Library
python-dotenv Library

## Installation Steps

# Clone the Repository:

bash
git clone https://github.com/your-repo/device-hub.git
cd device-hub

# Install Python Dependencies:

pip install -r requirements.txt
Install and Configure MQTT Broker:

# Install Mosquitto:
bash
sudo apt-get install mosquitto

# Enable and start the broker:
bash
sudo systemctl enable mosquitto
sudo systemctl start mosquitto

# Configure Mosquitto (/etc/mosquitto/mosquitto.conf):
listener 1883 192.168.x.x
allow_anonymous true

# Create .env File:

Create a .env file in the root directory with the following content:
HUB_ID=unique_hub_id_123
BROKER_ADDRESS=192.168.x.x

# Run the FastAPI Server:

uvicorn app.main:app --host 0.0.0.0 --port 8010
