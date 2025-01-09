import traceback
from fastapi import APIRouter, HTTPException
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
from model.deviceModel import LoginParams, RegisterDwellerParams, get_userParams, RegisterParams, ResponseInfo, ResponseObject


userRouter = APIRouter()
user_manager = UserManager()
token_manager = TokenManager()

@userRouter.post("/register-manager", response_model=ResponseObject)
async def register_user(params: RegisterParams):
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
    

@userRouter.post("/register-dweller", response_model=ResponseObject)
async def register_user(params: RegisterDwellerParams):
    try:
        # Verify the token
        home_id = token_manager.verify_token(token=params.token, email=params.email)
        if not home_id:
            raise HTTPException(status_code=400, detail="Invalid or expired token")

        # Update the user
        user_id = user_manager.update_user(
            email=params.email, password=params.password, name=params.name, home_id=home_id
        )
        if not user_id:
            raise HTTPException(status_code=500, detail="Failed to update user")

        # Success response
        response_info = ResponseInfo(
            statusCode=200, message="Success", detail="User updated successfully."
        )
        return ResponseObject(data={"user_id": user_id}, statusCode=200, responseInfo=response_info)
    except HTTPException as http_exc:
        # Re-raise HTTP exceptions
        raise http_exc
    except Exception as e:
        # Log and return a generic internal server error
        traceback.print_exc()
        raise HTTPException(status_code=500, detail="Internal server error.")



@userRouter.post("/login", response_model=ResponseObject)
async def login_user(params: LoginParams):
    try:
        
        user_id = user_manager.login_user(params.email, params.password)
        if user_id:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Logged in successfully"
            )
            return ResponseObject(data={'user_id' : user_id}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to log in")
    except Exception as e:
        print("error: dasda ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    


@userRouter.post("/user", response_model=ResponseObject)
async def get_user(id: get_userParams):
    print(id)
    try:
        user = user_manager.get_user_by_id(id=id.id)
        if user:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data={"user": user}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error.")   