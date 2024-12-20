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


class Section:
    def __init__(self, title: str, description: str, sections=None):
        self.title = title
        self.description = description
        self.sections = sections if sections else []

    def to_dict(self):
        return {
            "title": self.title,
            "description": self.description,
            "sections": [section.to_dict() for section in self.sections] if self.sections else []
        }

class Document:
    def __init__(self, url: str, title: str, summary: str, keywords: list[str], sections: list[Section]):
        self.url = url
        self.title = title
        self.summary = summary
        self.keywords = keywords
        self.sections = sections

    def to_dict(self):
        return {
            "url": self.url,
            "title": self.title,
            "summary": self.summary,
            "keywords": self.keywords,
            "sections": [section.to_dict() for section in self.sections]
        }
class SummarizerChatRoom:
    def __init__(self, user_id: str, room_name: str,template: str = "general", room_uuid: str = None, docData = {},widgets = {}, states = {}, room_members: list[str] = [], nodes = [], mapProgress = {} ):
        self.user_id = user_id
        self.room_name = room_name
        self.room_uuid = room_uuid if room_uuid else str(ObjectId())  # Assuming ObjectId is imported from bson
        self.room_members = room_members
        self.created_by = user_id
        self.date_created = datetime.now()
        self.date_modified = datetime.now()
        self.docData = docData
        self.widgets = widgets
        self.template = template
        self.mapProgress = mapProgress
        self.nodes = nodes
        self.states = states
        self.last_modified_by = user_id


    def to_dict(self):
        return {
            "_id": str(self.room_uuid),
            "created_by": self.created_by,
            "date_created": self.date_created.isoformat(),
            "date_modified": self.date_modified.isoformat(),
            "last_modified_by": self.last_modified_by,
            "room_members": self.room_members,
            "room_name": self.room_name,
            "room_uuid": self.room_uuid,
            "user_id": self.user_id,
            "docData" : self.docData,
            "widgets" : self.widgets,
            "mapProgress": self.mapProgress,
            "nodes" : self.nodes,
            "template" : self.template,
            "states" : self.states
        }

class SummarizerChatMessage:
    def __init__(self, isUser: bool,  room_uuid: str,message_id: str, sender_id: str, timestamp: datetime, intent: str, message_content: str):
        self.room_uuid = room_uuid
        self.message_id = message_id
        self.sender_id = sender_id
        self.timestamp = timestamp
        self.isUser = isUser
        self.intent = intent
        self.message_content = message_content

    def to_dict(self):
        return {
            "room_uuid" : self.room_uuid,
            "message_id": self.message_id,
            "isUser": self.isUser,
            "sender_id": self.sender_id,
            "timestamp": self.timestamp.isoformat(),
            "intent": self.intent,
            "message_content": self.message_content,
        }

    def __str__(self):
        if self.isUser:
            x = 'User'
        else:
            x = 'Bot'
        return f"{x}: {self.content}"
    

class RoomCreateRequest(BaseModel):
    room_name: str
    user_id: str
    template: str

class clear_roomsParams(BaseModel):
    id: str

class RegisterParams(BaseModel):
    email: str
    password: str   

class AuthParams(BaseModel):
    userId: str
    profileId: str   

class addColumnParams(BaseModel):
    header: str
    prompt: str
    room_uuid : str
    user_id : str

class get_userParams(BaseModel):
    id: str


