import traceback
from fastapi import APIRouter, HTTPException
from repositories.hub_repository import HubManager
from repositories.home_repository import HomeManager
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
from model.deviceModel import LoginParams, RegisterDwellerParams, UpdateDwellerParams, get_userParams, RegisterParams, ResponseInfo, ResponseObject, settingsParams


userRouter = APIRouter()
user_manager = UserManager()
token_manager = TokenManager()
home_manager = HomeManager()
hub_manager = HubManager()

@userRouter.post("/register-manager", response_model=ResponseObject)
async def register_user(params: RegisterParams):
    try:
        
        message_id = user_manager.create_user(
            email=params.email,
            password=params.password,
            name=params.name,
            role='manager'
        )

        if not message_id:
            raise HTTPException(status_code=500, detail="Failed to create manager account.")

        home_id = home_manager.create_home(
            home_name='My Home', 
            address='somewhere on Earth', 
            manager_id=message_id, 
            hub_id=params.hub_id
        )

        if not home_id:
            raise HTTPException(status_code=500, detail="Failed to create home.")


        update_user = user_manager.update_user(
            email=params.email,
            password=params.password,
            name=params.name,
            home_id=home_id
        )

        if not update_user:
            raise HTTPException(status_code=500, detail="Failed to update user with home ID.")

        # If all steps are successful
        response_info = ResponseInfo(
            statusCode=200, message="Success", detail="User and home created successfully."
        )
        return ResponseObject(data={"user_id": message_id}, statusCode=200, responseInfo=response_info)

    except Exception as e:
        print(f"error: {e}")
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
        return ResponseObject(data={"user_id": user_id, 'home_id' : home_id}, statusCode=200, responseInfo=response_info)
    except HTTPException as http_exc:
        # Re-raise HTTP exceptions
        raise http_exc
    except Exception as e:
        # Log and return a generic internal server error
        traceback.print_exc()
        raise HTTPException(status_code=500, detail="Internal server error.")

@userRouter.post("/update-user", response_model=ResponseObject)
async def update_user(params: UpdateDwellerParams):
    try:
        user = user_manager.update_user_profile(user_id=params.user_id, key=params.key, value=params.value)
        if user:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data=True, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail="Internal server error.")   



@userRouter.post("/login", response_model=ResponseObject)
async def login_user(params: LoginParams):
    try:
        
        user_id, home_id = user_manager.login_user(params.email, params.password)
        if user_id and home_id:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Logged in successfully"
            )
            return ResponseObject(data={'user_id' : user_id, 'home_id' : home_id}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to log in")
    except Exception as e:
        print("error: dasda ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    


@userRouter.post("/user", response_model=ResponseObject)
async def get_user(id: get_userParams):
    print(id)
    try:
        user = user_manager.get_user_by_id(id=id.user_id)
        home = home_manager.get_home_by_id(id.home_id)
        rooms = hub_manager.getRooms(home['hub_id'])
        if rooms:
            home['rooms'] = rooms
        if user and home:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data={"user": user, 'home' : home}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error.")   
    
@userRouter.post("/update-settings", response_model=ResponseObject)
async def update_settings(params: settingsParams):
    try:
        user = user_manager.update_settings(id=params.user_id, value=params.value, path=params.path)
        if user:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data=True, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail="Internal server error.")   