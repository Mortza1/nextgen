from datetime import datetime
from bson import ObjectId
from app.db_config import MongoConnection
from werkzeug.security import generate_password_hash, check_password_hash

from model.deviceModel import User

class UserManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["users"]
        except Exception as e:
            print("error: ", e)

    def create_user(self, email, password, name, role, managed_homes = [], associated_homes = []):
        try:
            # Check if the username (email) already exists
            existing_user = self.collection.find_one({"email": email})
            if existing_user:
                if len(associated_homes) != 0:
                    existing_user["associated_homes"].append(associated_homes[0])
                    self.collection.update_one({"email": email}, {"$set": {"associated_homes": existing_user["associated_homes"]}})
                    return str(existing_user["_id"])
                else:
                    print("User with this username already exists.")
                    return None

            # Hash the password and prepare user data
            hashed_password = generate_password_hash(password)
            user = User(name=name, email=email, password=hashed_password, role=role, managed_homes=managed_homes, associated_homes=associated_homes)
            user_data = user.to_dict()
            # Insert the new user into the collection
            result = self.collection.insert_one(user_data)
            return str(result.inserted_id)  # Return the unique user ID

        except Exception as e:
            print(f"An error occurred while creating user: {e}")
            return None
        
    def login_user(self, email, password):
        try:
            # Find the user by email
            existing_user = self.collection.find_one({"email": email})
            if not existing_user:
                print("User not found.")
                return None

            # Verify the password
            if not check_password_hash(existing_user['password'], password):
                print("Invalid password.")
                return None

            
            return str(existing_user["_id"])

        except Exception as e:
            print(f"An error occurred during login: {e}")
            return None


    def get_user_by_id(self, id):
        try:
            # Ensure id is converted to ObjectId
            user = self.collection.find_one({"_id": ObjectId(id)})  
            if user:
                user['_id'] = str(user['_id'])  # Convert ObjectId to string
                return user
            else:
                return None
        except Exception as e:
            import traceback
            traceback.print_exc()  # Print full stack trace for debugging
            print(f"An error occurred while retrieving user: {e}")
            return None
