from bson import ObjectId
from app.db_config import MongoConnection

class DeviceManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["devices"]
        except Exception as e:
            print("error: ", e)

    def get_device(self, device_id):
        try:
            device = self.collection.find_one({"_id": ObjectId(device_id)})
            if device:
                # Convert ObjectId to string
                device["_id"] = str(device["_id"])
                return device
        except Exception as e:
            print("error:", e)
            import traceback
            traceback.print_exc()
            raise Exception("device fetch failed.")
        
    def update_device(self, device_id, name):
        try:
            device = self.collection.update_one({"_id": ObjectId(device_id)}, {"$set": {"name": name}})
            if device:
                return True
        except Exception as e:
            print("error:", e)
            import traceback
            traceback.print_exc()
            raise Exception("device update failed.")
    

