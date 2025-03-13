from fastapi import FastAPI, WebSocket, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import redis
import asyncio
from pydantic import BaseModel
from api.userController import userRouter
from api.managementController import managerRouter
from api.userDeviceController import deviceRouter

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(managerRouter, prefix="/management")
app.include_router(userRouter, prefix="/auth")
app.include_router(deviceRouter, prefix="/device")

# WebSocket clients storage
websocket_clients = set()

# Configure Redis
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)
pubsub = redis_client.pubsub()

# WebSocket endpoint to receive state updates in real-time
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    websocket_clients.add(websocket)
    print(f"New WebSocket connection from {websocket.client.host}")
    
    try:
        while True:
            await websocket.receive_text()  # Keep connection open
    except Exception as e:
        print(f"Error: {e}")
        websocket_clients.remove(websocket)
        print(f"WebSocket connection closed from {websocket.client.host}")


# Function to send updates to all connected WebSocket clients
async def send_websocket_update(device_id, new_state):
    # print(f"Sending update to WebSocket clients: {device_id} -> {new_state}")
    for client in websocket_clients:
        try:
            await client.send_json({"device_id": device_id, "state": new_state})
        except Exception as e:
            print(f"Error sending message to WebSocket client: {e}")


# Listen to Redis for new device state updates and notify WebSockets
async def listen_to_device_updates():
    while True:
        message = pubsub.get_message()
        if message:
            data = message['data'].decode()
            device_id, new_state = data.split(":")
            # Send update to all WebSocket clients
            await send_websocket_update(device_id, new_state)
        await asyncio.sleep(1)

# Start background task to listen for updates from Redis
@app.on_event("startup")
async def start_listening():
    asyncio.create_task(listen_to_device_updates())

# Pydantic model for device update payload
class DeviceUpdate(BaseModel):
    device_id: str
    new_state: str

# Endpoint to receive device state updates from the listener service
@app.post("/device_update")
async def device_update(data: DeviceUpdate):
    try:
        # Publish the device update to Redis
        redis_client.publish("device_updates", f"{data.device_id}:{data.new_state}")

        # Run WebSocket update as a background task
        asyncio.create_task(send_websocket_update(data.device_id, data.new_state))

        return {"message": "Device state updated successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing device update: {str(e)}")

