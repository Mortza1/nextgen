#!/bin/bash

# Start the MQTT broker
echo "Starting MQTT broker..."
sudo systemctl start mosquitto
if [ $? -eq 0 ]; then
    echo "MQTT broker started successfully."
else
    echo "Failed to start MQTT broker."
    exit 1
fi

# Navigate to the hub project directory
echo "Navigating to the hub project directory..."
cd /path/to/your/hub/project || exit 1

# Activate Python virtual environment if you have one
# echo "Activating virtual environment..."
# source venv/bin/activate

# Start the FastAPI server using Uvicorn on port 8010
echo "Starting FastAPI server on port 8010..."
uvicorn app.main:app --host 0.0.0.0 --port 8010
if [ $? -eq 0 ]; then
    echo "FastAPI server started successfully."
else
    echo "Failed to start FastAPI server."
    exit 1
fi
