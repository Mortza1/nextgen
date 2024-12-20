#!/usr/bin/env python
from fastapi import FastAPI
from app import app
from repositories.user_repository import UserManager
from repositories.room_repository import SummarizerChatRoomManager

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8070)
    # uvicorn.run(app, host="localhost", port=8080)