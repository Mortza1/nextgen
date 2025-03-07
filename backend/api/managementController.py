from fastapi import APIRouter, HTTPException
import traceback
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
from repositories.home_repository import HomeManager
from model.deviceModel import AddHomeParams, HomeParams, InviteParams, ResponseInfo, ResponseObject, User, homeDwellersParams


managerRouter = APIRouter()
home_manager = HomeManager()
user_manager = UserManager()
token_manager = TokenManager()

@managerRouter.post("/add-home", response_model=ResponseObject)
async def add_home(params: AddHomeParams):
    try:
        message_id = home_manager.create_home(address=params.address, manager_id=params.manager_id, home_name=params.home_name)
        if message_id:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Home inserted successfully."
            )
            return ResponseObject(data={"home_id": message_id}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to add home")
    except Exception as e:
        print("error: dasda ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    

@managerRouter.post("/homes", response_model=ResponseObject)
async def get_homes(params: HomeParams):
    try:
        print("manager_id: ", params.manager_id)
        homes = home_manager.get_homes_by_manager(str(params.manager_id))
        if homes:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Homes retrieved successfully."
            )
            return ResponseObject(data={"homes": homes}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=404, detail="No homes found for the given manager.")
    except Exception as e:
        print("error: ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")


@managerRouter.post("/invite-dweller", response_model=ResponseObject)
async def invite(params: InviteParams):
    try:
        user_id = user_manager.create_user(email=params.email, password='', name='', role='dweller', associated_homes=[params.house_id])
        add_dweller = home_manager.add_dweller(user_id, params.house_id)
        token = token_manager.create_token(home_id=params.house_id, manager_id=params.manager_id, email=params.email)
        email_sent = token_manager.send_email(recipient_email=params.email, token=token)
        if email_sent:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Email sent successfully."
            )
            return ResponseObject(data={"email_sent" : email_sent}, statusCode=200, responseInfo=response_info)
    except Exception as e:
        traceback.print_exc()
        print("error: ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")

@managerRouter.post("/home-dwellers", response_model=ResponseObject)
async def get_dwellers_of_home(params: homeDwellersParams):
    try:
        users = []
        for i in params.user_ids:
            print("user_id", i)
            user = user_manager.get_user_by_id(i)
            if user:
                users.append(user)
            else:
                print('user is empty')
        response_info = ResponseInfo(
                statusCode=200, message="Success", detail="users fetched successfully."
            )
        return ResponseObject(data={"users" : users}, statusCode=200, responseInfo=response_info)
    except Exception as e:
        traceback.print_exc()
        print("error: ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")

