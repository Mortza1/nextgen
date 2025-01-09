from bson import ObjectId
from app.db_config import MongoConnection

from model.deviceModel import Home

class DeviceManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["devices"]
        except Exception as e:
            print("error: ", e)

    # def create_home(self, home_name: str, address: str, manager_id: str, dwellers: list[dict] = [], devices: list[str] = []):
    #     try:
    #         home = Home(name=home_name, address=address, manager_id=manager_id, dwellers=dwellers, devices=devices)
    #         home_data = home.to_dict()
    #         # Insert the new home into the collection
    #         result = self.collection.insert_one(home_data)
    #         return str(result.inserted_id)  # Return the unique home ID

    #     except Exception as e:
    #         print(f"An error occurred while creating home: {e}")
    #         return None 

