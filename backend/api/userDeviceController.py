import traceback
from fastapi import APIRouter, HTTPException
from repositories.devices_repository import DeviceManager
from repositories.home_repository import HomeManager
from repositories.hub_repository import HubManager
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
from model.deviceModel import ConnectDeviceParams, GetDevicesParams, ResponseInfo, ResponseObject


deviceRouter = APIRouter()
user_manager = UserManager()
hub_manager = HubManager()
token_manager = TokenManager()
device_manager = DeviceManager()
home_manager = HomeManager()

@deviceRouter.post("/register-device", response_model=ResponseObject)
async def register_device(params: ConnectDeviceParams):
    try:
        register = hub_manager.connect_device(params.hub_id, params.device_id)
        if register:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="device connected successfully."
            )
            return ResponseObject(data=register, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to connect device")
    except Exception as e:
        print("error: dasda ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    

@deviceRouter.post("/get_devices", response_model=ResponseObject)
async def get_devices(params: GetDevicesParams):
    try:
        if params.hub_id:
            devices = []
            device_list = hub_manager.getDevices(params.hub_id)
            for id in device_list:
                d = device_manager.get_device(id)
                devices.append(d)
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="devices fetched successfully."
            )
            return ResponseObject(data=devices, statusCode=200, responseInfo=response_info)
        else:
            user = user_manager.get_user_by_id(params.user_id)
            home_id = user['associated_homes'][0]
            home = home_manager.get_home_by_id(home_id)
            hub_id = home['hub_id']
            device_list = hub_manager.getDevices(hub_id)
            print(device_list, 'uuuuuuuuuuuuuu')
            devices = []
            for id in device_list:
                d = device_manager.get_device(id)
                devices.append(d)
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="devices fetched successfully."
            )
            return ResponseObject(data={"devices": devices, "hub_id" : hub_id}, statusCode=200, responseInfo=response_info)
    
    except Exception as e:
        print("error: ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    
    

