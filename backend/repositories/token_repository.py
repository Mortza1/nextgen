from datetime import datetime, timedelta
import hashlib
import os
import traceback
from dotenv import load_dotenv
load_dotenv()
from app.db_config import MongoConnection
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

from model.deviceModel import InvitationTokens

class TokenManager:
    def __init__(self):
        try:
            self.db_connection = MongoConnection().get_db()
            self.collection = self.db_connection["tokens"]
            self.collection.create_index("token", unique=True)
        except Exception as e:
            print("error: ", e)

    def create_token(self, home_id: str, manager_id: str, email: str):
        try:
            raw_data = f"{email}:{home_id}:{manager_id}:{datetime.now().isoformat()}"
            token = hashlib.sha256(raw_data.encode()).hexdigest()
            expires_at = datetime.utcnow() + timedelta(days=30)
            token_temp = InvitationTokens(token=token, email=email, home_id=home_id, expires_at=expires_at)
            token_data = token_temp.to_dict()
            self.collection.insert_one(token_data)
            return token

        except Exception as e:
            traceback.print_exc()
            print(f"An error occurred while creating token: {e}")
            return None
        
    def send_email(self, recipient_email: str, token: str):
        try:
            sender_email = os.getenv('EMAIL')
            sender_password = os.getenv("PASSWORD")
            smtp_server = "smtp.gmail.com"
            smtp_port = 587

            msg = MIMEMultipart()
            msg["From"] = sender_email
            msg["To"] = recipient_email
            msg["Subject"] = 'token for home invitation'
            msg.attach(MIMEText(f'The following is your token: ${token}', "plain"))
            with smtplib.SMTP(smtp_server, smtp_port) as server:
                server.starttls()
                server.login(sender_email, sender_password)
                server.sendmail(sender_email, recipient_email, msg.as_string())
            print("Email sent successfully!")
            return True
        
        except Exception as e:
            traceback.print_exc()
            print("Error:", e)
            return False