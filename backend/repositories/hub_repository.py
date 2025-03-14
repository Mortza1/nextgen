from bson import ObjectId
from app.db_config import MongoConnection

class HubManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["hubs"]
        except Exception as e:
            print("error: ", e)

    def connect_device(self, hub_id, device_id):
        try:
            result = self.collection.update_one(
                {"_id": ObjectId(hub_id)},
                {"$addToSet": {"devices": device_id}}
            )
            if result.modified_count == 1:
                print(f"Device {device_id} successfully added to hub {hub_id}.")
                return True
            else:
                print(f"No hub found with ID {hub_id}.")
                return False
        except Exception as e:
            print("error: ", e)
            return {"status": "error", "message": str(e)}
    
    def getDevices(self, hub_id):
        try:
            hub = self.collection.find_one({"_id": ObjectId(hub_id)})
            ret = []
            for i in hub['rooms']:
                ret.extend(i['devices'])
            return ret
            
        except Exception as e:
            print("error: ", e)
            raise Exception("device fetch failed. ")
    
    def getRooms(self, hub_id):
        try:
            hub = self.collection.find_one({"_id": ObjectId(hub_id)})
            return hub['rooms']
        except Exception as e:
            print("error: ", e)
            raise Exception("room fetch failed. ")
        
    def add_room(self, hub_id, room_name):
        try:
            result = self.collection.update_one(
                {"_id": ObjectId(hub_id)},
                {"$addToSet": {"rooms": {"name": room_name, "devices": []}}}
            )
        except Exception as e:
            print("error: ", e)
            raise Exception("room add failed. ")
        

    def add_device(self, hub_id, device_id, room):
        try:
            # Find the hub and update the specific room's devices array
            result = self.collection.update_one(
                {
                    "_id": ObjectId(hub_id),  # Match the hub by its ID
                    "rooms.name": room,       # Match the room by its name
                },
                {
                    "$addToSet": {"rooms.$.devices": device_id}  # Add device_id to the matched room's devices array
                }
            )

            # Check if the update was successful
            if result.modified_count == 1:
                print(f"Device {device_id} successfully added to room {room}.")
                return True
            else:
                print(f"No hub found with ID {hub_id} or no room found with name {room}.")
                return False
        except Exception as e:
            print("error: ", e)
            return {"status": "error", "message": str(e)}