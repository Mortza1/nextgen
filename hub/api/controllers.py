from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from mqtt.client import publish_message

router = APIRouter()

# Define request schemas
class DeviceCommand(BaseModel):
    device_id: str
    command: str

@router.post("/devices/{device_id}/command")
async def send_device_command(device_id: str, command: DeviceCommand):
    try:
        topic = f"devices/{device_id}/commands"
        await publish_message(topic, command.command)
        return {"status": "success", "message": f"Command sent to device {device_id}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
