import traceback
from fastapi import APIRouter, HTTPException
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
from model.deviceModel import LoginParams, RegisterDwellerParams, get_userParams, RegisterParams, ResponseInfo, ResponseObject


deviceRouter = APIRouter()
user_manager = UserManager()
token_manager = TokenManager()

@deviceRouter.post("/register-device", response_model=ResponseObject)
async def register_device(params: RegisterParams):
    try:
        message_id = user_manager.create_user(email = params.email, password=params.password, name=params.name, role='manager')
        if message_id:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="User inserted successfully."
            )
            return ResponseObject(data={"user_id": message_id}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to add user")
    except Exception as e:
        print("error: dasda ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    

