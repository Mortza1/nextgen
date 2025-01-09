#!/usr/bin/env python
import uvicorn
from fastapi import FastAPI
from api.controllers import router as api_router
from mqtt.client import start_mqtt_client

app = FastAPI()

# Include the router
app.include_router(api_router)

# Start the MQTT client when FastAPI starts
@app.on_event("startup")
async def startup_event():
    await start_mqtt_client()

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8010) 
