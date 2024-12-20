from datetime import datetime
from bson import ObjectId
from app.db_config import MongoConnection
from werkzeug.security import generate_password_hash, check_password_hash

class UserManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["users"]
        except Exception as e:
            print("error: ", e)

    def create_user(self, email, password):
        try:
            # Check if the username (email) already exists
            existing_user = self.collection.find_one({"email": email})
            if existing_user:
                print("User with this username already exists.")
                return None

            # Hash the password and prepare user data
            hashed_password = generate_password_hash(password)
            user_id = str(ObjectId())
            user_data = {
                "user_id": user_id,
                "email": email,
                "password": hashed_password,
                "subscription": 'basic',
                "created_at": datetime.now(),
                "updated_at": datetime.now(),
                "documents" : 0,
                "generations" : 0,
                "chats" : 0
            }

            # Insert the new user into the collection
            result = self.collection.insert_one(user_data)
            return user_id  # Return the unique user ID

        except Exception as e:
            print(f"An error occurred while creating user: {e}")
            return None


    def auth(self, userId, profileId):
        try:
            # Check if the username (email) already exists
            existing_user = self.collection.find_one({"user_id": userId})
            if existing_user:
                print("User with this username already exists.")
                return userId

            # Hash the password and prepare user data
            user_data = {
                "user_id": userId,
                'profile_id' : profileId,
                "subscription": 'basic',
                "created_at": datetime.now(),
                "updated_at": datetime.now(),
                "documents" : 0,
                "generations" : 0,
                "chats" : 0
            }

            # Insert the new user into the collection
            result = self.collection.insert_one(user_data)
            return userId

        except Exception as e:
            print(f"An error occurred while creating user: {e}")
            return None

    def get_user_by_email(self, email):
        try:
            user = self.collection.find_one({"email": email})
            if user:
                return user
            else:
                return None
        except Exception as e:
            print(f"An error occurred while retrieving user: {e}")
            return None

    def list_all_users(self):
        try:
            # Retrieve all users from the collection
            users = list(self.collection.find({}))
            return users
        except Exception as e:
            print(f"An error occurred while retrieving users: {e}")
            return None
        
    def get_user_by_id(self, id):
        try:
            user = self.collection.find_one({"user_id": id})
            if user:
                user.pop("_id", None)
                return user
            else:
                return None
        except Exception as e:
            print(f"An error occurred while retrieving user: {e}")
            return None
            
    def verify_password(self, email, password):
        user = self.get_user_by_email(email)
        if user and check_password_hash(user["password"], password):
            return user["user_id"]  # Return user ID if password is correct
        return None

    def update_user(self, username, update_data):
        try:
            self.collection.update_one(
                {"username": username},
                {"$set": update_data, "$currentDate": {"updated_at": True}},
            )
            return True
        except Exception as e:
            print(f"An error occurred while updating user: {e}")
            return False
    
    def update_documents_count(self, room_uuid, increment_by, summarizer_chat_room_manager):
        try:
            room = summarizer_chat_room_manager.collection.find_one({"room_uuid": room_uuid})
            if not room:
                print(f"Room with UUID {room_uuid} not found.")
                return False

            user_id = room.get("created_by")
            if not user_id:
                print(f"Room with UUID {room_uuid} does not have a 'created_by' field.")
                return False

            result = self.collection.update_one(
                {"user_id": user_id},
                {"$inc": {"documents": increment_by}, "$currentDate": {"updated_at": True}}
            )
            return result.modified_count > 0
        except Exception as e:
            print(f"An error occurred while updating documents count: {e}")
            return False
        
    def update_generations_count(self, room_uuid, increment_by, summarizer_chat_room_manager):
        try:
            room = summarizer_chat_room_manager.collection.find_one({"room_uuid": room_uuid})
            if not room:
                print(f"Room with UUID {room_uuid} not found.")
                return False

            user_id = room.get("created_by")
            if not user_id:
                print(f"Room with UUID {room_uuid} does not have a 'created_by' field.")
                return False

            result = self.collection.update_one(
                {"user_id": user_id},
                {"$inc": {"generations": increment_by}, "$currentDate": {"updated_at": True}}
            )
            return result.modified_count > 0
        except Exception as e:
            print(f"An error occurred while updating generations count: {e}")
            return False
        
    def update_chats_count(self, room_uuid, increment_by, summarizer_chat_room_manager):
        try:
            room = summarizer_chat_room_manager.collection.find_one({"room_uuid": room_uuid})
            if not room:
                print(f"Room with UUID {room_uuid} not found.")
                return False

            user_id = room.get("created_by")
            if not user_id:
                print(f"Room with UUID {room_uuid} does not have a 'created_by' field.")
                return False

            result = self.collection.update_one(
                {"user_id": user_id},
                {"$inc": {"chats": increment_by}, "$currentDate": {"updated_at": True}}
            )
            return result.modified_count > 0
        except Exception as e:
            print(f"An error occurred while updating chats count: {e}")
            return False

    def initialize_missing_fields(self):
        try:
            users = self.list_all_users()
            if not users:
                print("No users found.")
                return False

            for user in users:
                print(user)
                update_data = {}
                if "documents" not in user:
                    update_data["documents"] = 0
                if "generations" not in user:
                    update_data["generations"] = 0
                if "chats" not in user:
                    update_data["chats"] = 0

                if update_data:
                    self.collection.update_one(
                        {"user_id": user["user_id"]},
                        {"$set": update_data, "$currentDate": {"updated_at": True}}
                    )

            return True
        except Exception as e:
            print(f"An error occurred while initializing missing fields: {e}")
            return False
