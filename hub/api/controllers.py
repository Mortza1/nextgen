from datetime import datetime
import json
from fastapi import APIRouter, BackgroundTasks, HTTPException
from pydantic import BaseModel
from mqtt.client import publish_message
import httpx
from dotenv import load_dotenv
import os
load_dotenv()

router = APIRouter()

# Define request schemas
class DeviceCommand(BaseModel):
    device_id: str
    command: str

@router.post("/devices/{device_id}/command")
async def send_device_command(device_id: str, command: DeviceCommand, background_tasks: BackgroundTasks):
    try:
        topic = f"devices/{device_id}/command"
        # Add the publishing task to the background task queue
        background_tasks.add_task(publish_message, topic, command.command)
        return {"status": "success", "message": f"Command sent to device {device_id}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/devices/{device_id}")
async def add_device(device_id: str):
    try:
        # Define the backend API URL
        backend_url = f"{os.getenv('URL')}/device/register-device"
        
        # Define the payload
        payload = {"device_id": device_id, "hub_id" : os.getenv("HUB_ID")}

        # Make an asynchronous POST request to the backend API
        async with httpx.AsyncClient() as client:
            response = await client.post(backend_url, json=payload)
        
        # Check the response status
        if response.status_code == 200:
            return {"status": "success", "message": f"Device {device_id} added to the backend successfully"}
        else:
            raise HTTPException(status_code=response.status_code, detail=response.text)
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 

@router.get("/devices/{hub_id}")
async def get_device_data(hub_id: str):  # Added `hub_id` as a parameter
    try:
        base_path = os.path.join(os.path.dirname(__file__), "..", "device_data")

        if not os.path.exists(base_path):
            raise HTTPException(status_code=404, detail="Device data folder not found")

        device_files = [f for f in os.listdir(base_path) if f.endswith(".json")]

        if not device_files:
            raise HTTPException(status_code=404, detail="No device files found")

        latest_data = []

        for file_name in device_files:
            file_path = os.path.join(base_path, file_name)

            try:
                with open(file_path, "r") as file:
                    # Load and validate JSON data
                    data = json.load(file)

                    # Check if data is a list and contains valid JSON objects
                    if isinstance(data, list) and all(isinstance(item, dict) for item in data):
                        latest_data.append({file_name: data[-1]})
                    else:
                        print(f"Invalid JSON structure in {file_name}")
            
            except json.JSONDecodeError as e:
                print(f"Error decoding JSON from {file_name}: {e}")

        if not latest_data:
            raise HTTPException(status_code=404, detail="No latest device data found")

        return latest_data

    except Exception as e:
        print(f"Server error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/devices/today/{hub_id}")
async def get_device_data_today(hub_id: str):
    try:
        # Assuming device data is one folder back from the current working directory
        base_path = os.path.join(os.path.dirname(__file__), "..", "device_data")

        # Check if the folder exists
        if not os.path.exists(base_path):
            raise HTTPException(status_code=404, detail="Device data folder not found")

        # Get all files in the device_data folder
        device_files = [f for f in os.listdir(base_path) if f.endswith(".json")]  # Filter by hub_id

        if not device_files:
            raise HTTPException(status_code=404, detail="No device files found")

        today_data = []
        today_date = datetime.now().strftime("%Y-%m-%d")  # Current date in YYYY-MM-DD format

        # Loop through each file, get the entries for today only
        for file_name in device_files:
            file_path = os.path.join(base_path, file_name)

            with open(file_path, "r") as file:
                # Assuming each file contains a JSON array of objects
                data = json.load(file)

                # Filter data for today
                for entry in data:
                    timestamp = entry.get("timestamp")
                    if timestamp:
                        entry_date = timestamp.split(" ")[0]  # Extract date part (YYYY-MM-DD)
                        if entry_date == today_date:
                            today_data.append({file_name: entry})

        if not today_data:
            raise HTTPException(status_code=404, detail="No data for today found")

        return today_data

    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail=str(e))




