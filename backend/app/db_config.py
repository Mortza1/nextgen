from pymongo import MongoClient

# Define the MongoDB URI and database name
MONGO_URI = 'mongodb+srv://murtaza0903:murtaza110@cluster0.ftlmj.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'
MONGO_DB_NAME = 'nextdb'

class MongoConnection:
    @staticmethod
    def get_db():
        client = MongoClient(MONGO_URI)
        db = client[MONGO_DB_NAME]
        return db
