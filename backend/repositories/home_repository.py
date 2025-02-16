from bson import ObjectId
from app.db_config import MongoConnection

from model.deviceModel import Home

class HomeManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["homes"]
        except Exception as e:
            print("error: ", e)

    def create_home(self, home_name: str, address: str, manager_id: str, dwellers: list[dict] = [], devices: list[str] = []):
        try:
            home = Home(name=home_name, address=address, manager_id=manager_id, dwellers=dwellers, devices=devices)
            home_data = home.to_dict()
            # Insert the new home into the collection
            result = self.collection.insert_one(home_data)
            return str(result.inserted_id)  # Return the unique home ID

        except Exception as e:
            print(f"An error occurred while creating home: {e}")
            return None 
    
    def get_homes_by_manager(self, manager_id: str):
        try:
            # Find all homes with the same manager_id
            homes_cursor = self.collection.find({"manager_id": manager_id})
            
            # Convert the cursor to a list of homes and convert ObjectId to string
            homes_list = []
            for home in homes_cursor:
                # Convert ObjectId to string
                home["_id"] = str(home["_id"])
                homes_list.append(home)
            
            return homes_list
        
        except Exception as e:
            print(f"An error occurred while retrieving homes: {e}")
            return None
    
    def add_dweller(self, user_id: str, home_id: str):
        try:
            data = {"user_id": user_id, 'status': 'invited'}
            result = self.collection.update_one(
                {"_id": ObjectId(home_id)},  # Convert home_id to ObjectId
                {"$addToSet": {"dwellers": data}}  # Add user_id to dwellers if not already present
            )
            return result.modified_count > 0  # Returns True if a document was updated
        except Exception as e:
            print(f"An error occurred while updating dwellers: {e}")
            return None
        
    def get_home_by_id(self, home_id: str):
        try:
            home = self.collection.find_one({"_id": ObjectId(home_id)})
            if home:
                return home
        except Exception as e:
            print("error: ", e)
            raise Exception("home fetch failsed. ")
            
    

