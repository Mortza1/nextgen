import traceback
from fastapi import APIRouter, HTTPException
from repositories.devices_repository import DeviceManager
from repositories.home_repository import HomeManager
from repositories.hub_repository import HubManager
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
import httpx
from model.deviceModel import ConnectDeviceParams, GetDevicesParams, ResponseInfo, ResponseObject, SetDeviceParams


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
    
    

@deviceRouter.post("/update_device", response_model=ResponseObject)
async def update_device(params: SetDeviceParams):
    try:
        # Prepare the data for the external request
        url = f"http://localhost:8010/devices/{params.device_id}/command"
        headers = {"Content-Type": "application/json"}
        body = {
            "device_id": params.device_id,
            "command": params.command  # You can change to "turn_off" or other commands based on your use case
        }

        # Send the POST request to the new endpoint
        async with httpx.AsyncClient() as client:
            response = await client.post(url, json=body, headers=headers)

        # Check the response status code and handle accordingly
        if response.status_code == 200:
            # Return the successful response with data
            response_info = {
                "statusCode": 200,
                "message": "Success",
                "detail": "Device toggled successfully."
            }
            return ResponseObject(
                data=True,  # Send back the response data from the external endpoint
                statusCode=200,
                responseInfo=response_info
            )
        else:
            raise HTTPException(status_code=response.status_code, detail="Failed to toggle the device")
    
    except Exception as e:
        print(f"Error in toggle_light: {e}")
        raise HTTPException(status_code=500, detail="Internal server error.")