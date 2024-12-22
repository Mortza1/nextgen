from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
# from api.chatMessageController import chatMessageRouter
# from api.chatRoomController import chatRoomRouter
from api.userController import userRouter
from api.managementController import managerRouter
# from api.scriptController import scriptRouter

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# app.include_router(chatMessageRouter, prefix="/doc")
app.include_router(managerRouter, prefix="/management")
app.include_router(userRouter, prefix="/auth")
# app.include_router(scriptRouter, prefix="/doc")
