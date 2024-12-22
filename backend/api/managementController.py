from fastapi import APIRouter, HTTPException
from repositories.home_repository import HomeManager
from model.deviceModel import AddHomeParams, ResponseInfo, ResponseObject


managerRouter = APIRouter()
home_manager = HomeManager()

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
    