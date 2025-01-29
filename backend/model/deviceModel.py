from datetime import datetime
from bson import ObjectId
from pydantic import BaseModel, Field
from typing import Dict, Any

class ResponseInfo(BaseModel):
    statusCode: int
    message: str
    detail: str

    @classmethod
    def parse_obj(cls, obj):
        return cls(**obj)

    def dict(self, *args, **kwargs):
        return {
            "status_code": self.status_code,
            "message": self.message,
            "detail": self.detail,
        }

class ResponseObject(BaseModel):
    data: Any = Field(...)  # Use 'Any' for flexibility
    statusCode: int = Field(...)
    responseInfo: ResponseInfo = Field(...)

    class Config:
        arbitrary_types_allowed = True

class User:
    def __init__(self, name: str, email: str, role: str, password:str, managed_homes: list[str] = [], associated_homes: list[str] = []):
        self.name = name
        self.password = password
        self.email = email
        self.role = role
        self.managed_homes = managed_homes
        self.associated_homes = associated_homes

    def to_dict(self):
        return {
            "name" : self.name,
            "email": self.email,
            "password" : self.password,
            "role": self.role,
            "managed_homes" : self.managed_homes,
            "associated_homes" : self.associated_homes
        }
    
class Home:
    def __init__(self, name: str, address: str, manager_id: str, hub_id: str = '', dwellers: list[dict] = []):
        self.name = name
        self.address = address
        self.manager_id = manager_id
        self.dwellers = dwellers
        self.hub_id = hub_id

    def to_dict(self):
        return {
            "name" : self.name,
            "address" : self.address,
            "manager_id" : self.manager_id,
            "dwellers" : self.dwellers,
            "hub_id" : self.hub_id
        }

class Device:
    def __init__(self, name: str, type: str, home_id: str, current_data: dict = {}, historical_data: dict = {}):
        self.name = name
        self.type = type
        self.home_id = home_id
        self.current_data = current_data
        self.historical_data = historical_data
        

    def to_dict(self):
        """
        Convert the DeviceModel instance to a dictionary.
        
        :return: Dictionary representation of the DeviceModel instance
        """
        return {
            "name" : self.name,
            "type" : self.type,
            "home_id" : self.home_id,
            "current_data" : self.current_data,
            "historical_data" : self.historical_data
        }
        
class Hub:
    def __init__(self, devices: list[str]):
        self.devices = devices
        

    def to_dict(self):
        """
        Convert the DeviceModel instance to a dictionary.
        
        :return: Dictionary representation of the DeviceModel instance
        """
        return {
            "devices" : self.devices
        }
        
class InvitationTokens:
    def __init__(self, token: str, email: str, home_id: str, expires_at: datetime, used: bool = False):
        self.token = token
        self.email = email
        self.expires_at = expires_at
        self.home_id = home_id
        self.used = used

    def to_dict(self):
        return {
            "token" : self.token,
            "email" : self.email,
            "home_id" : self.home_id,
            "used" : self.used,
            "expires_at" : self.expires_at
        }
    

class RoomCreateRequest(BaseModel):
    room_name: str
    user_id: str
    template: str

class clear_roomsParams(BaseModel):
    id: str

class RegisterParams(BaseModel):
    email: str
    password: str
    role: str = ''
    name: str
    token: str = ''
    associated_homes: list[str] = []
    managed_homes: list[str] = []

class ConnectDeviceParams(BaseModel):
    hub_id: str
    device_id: str

class GetDevicesParams(BaseModel):
    user_id: str
    hub_id : str

class RegisterDwellerParams(BaseModel):
    email: str
    password: str
    name: str
    token: str


class AddHomeParams(BaseModel):
    home_name: str
    address: str
    devices: list[str] = []
    manager_id: str
    dwellers: list[str] = []

class HomeParams(BaseModel):
    manager_id: str

class InviteParams(BaseModel):
    email: str
    house_id: str
    manager_id: str

class homeDwellersParams(BaseModel):
    user_ids : list[str]


class LoginParams(BaseModel):
    email: str
    password: str   

class addColumnParams(BaseModel):
    header: str
    prompt: str
    room_uuid : str
    user_id : str

class get_userParams(BaseModel):
    id: str


