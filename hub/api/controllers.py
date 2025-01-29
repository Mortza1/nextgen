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




