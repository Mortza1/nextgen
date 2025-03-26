import json
import os
import traceback
import uuid
import cohere
from fastapi import APIRouter, File, HTTPException, UploadFile
from services.send_command import send_command
from services.text_generation import use_llm
from repositories.hub_repository import HubManager
from repositories.home_repository import HomeManager
from repositories.token_repository import TokenManager
from repositories.user_repository import UserManager
from model.deviceModel import LoginParams, RegisterDwellerParams, UpdateDwellerParams, get_userParams, RegisterParams, ResponseInfo, ResponseObject, settingsParams
import torch
import librosa
from transformers import WhisperProcessor, WhisperForConditionalGeneration

userRouter = APIRouter()
user_manager = UserManager()
token_manager = TokenManager()
home_manager = HomeManager()
hub_manager = HubManager()

@userRouter.post("/register-manager", response_model=ResponseObject)
async def register_user(params: RegisterParams):
    try:
        
        message_id = user_manager.create_user(
            email=params.email,
            password=params.password,
            name=params.name,
            role='manager'
        )

        if not message_id:
            raise HTTPException(status_code=500, detail="Failed to create manager account.")

        home_id = home_manager.create_home(
            home_name='My Home', 
            address='somewhere on Earth', 
            manager_id=message_id, 
            hub_id=params.hub_id
        )

        if not home_id:
            raise HTTPException(status_code=500, detail="Failed to create home.")


        update_user = user_manager.update_user(
            email=params.email,
            password=params.password,
            name=params.name,
            home_id=home_id
        )

        if not update_user:
            raise HTTPException(status_code=500, detail="Failed to update user with home ID.")

        # If all steps are successful
        response_info = ResponseInfo(
            statusCode=200, message="Success", detail="User and home created successfully."
        )
        return ResponseObject(data={"user_id": message_id}, statusCode=200, responseInfo=response_info)

    except Exception as e:
        print(f"error: {e}")
        raise HTTPException(status_code=500, detail="Internal server error.")
    

@userRouter.post("/register-dweller", response_model=ResponseObject)
async def register_user(params: RegisterDwellerParams):
    try:
        # Verify the token
        home_id = token_manager.verify_token(token=params.token, email=params.email)
        if not home_id:
            raise HTTPException(status_code=400, detail="Invalid or expired token")

        # Update the user
        user_id = user_manager.update_user(
            email=params.email, password=params.password, name=params.name, home_id=home_id
        )
        if not user_id:
            raise HTTPException(status_code=500, detail="Failed to update user")

        # Success response
        response_info = ResponseInfo(
            statusCode=200, message="Success", detail="User updated successfully."
        )
        return ResponseObject(data={"user_id": user_id, 'home_id' : home_id}, statusCode=200, responseInfo=response_info)
    except HTTPException as http_exc:
        # Re-raise HTTP exceptions
        raise http_exc
    except Exception as e:
        # Log and return a generic internal server error
        traceback.print_exc()
        raise HTTPException(status_code=500, detail="Internal server error.")

@userRouter.post("/update-user", response_model=ResponseObject)
async def update_user(params: UpdateDwellerParams):
    try:
        user = user_manager.update_user_profile(user_id=params.user_id, key=params.key, value=params.value)
        if user:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data=True, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail="Internal server error.")   



@userRouter.post("/login", response_model=ResponseObject)
async def login_user(params: LoginParams):
    try:
        
        user_id, home_id = user_manager.login_user(params.email, params.password)
        if user_id and home_id:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Logged in successfully"
            )
            return ResponseObject(data={'user_id' : user_id, 'home_id' : home_id}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to log in")
    except Exception as e:
        print("error: dasda ", e)
        raise HTTPException(status_code=500, detail="Internal server error.")
    


@userRouter.post("/user", response_model=ResponseObject)
async def get_user(id: get_userParams):
    print(id)
    try:
        user = user_manager.get_user_by_id(id=id.user_id)
        home = home_manager.get_home_by_id(id.home_id)
        rooms = hub_manager.getRooms(home['hub_id'])
        if rooms:
            home['rooms'] = rooms
        if user and home:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data={"user": user, 'home' : home}, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal server error.")   
    
@userRouter.post("/update-settings", response_model=ResponseObject)
async def update_settings(params: settingsParams):
    
    try:
        user = user_manager.update_settings(id=params.user_id, value=params.value, path=params.path)
        if user:
            response_info = ResponseInfo(
                statusCode=200, message="Success", detail="Messages retrieved successfully."
            )
            return ResponseObject(data=True, statusCode=200, responseInfo=response_info)
        else:
            raise HTTPException(status_code=500, detail="Failed to fetch user")
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail="Internal server error.")   
    

def parse_cohere_output(cohere_output):
    """Parses Cohere's output string into a JSON object.

    Args:
        cohere_output: The string output from Cohere.

    Returns:
        A dictionary representing the JSON object, or None if parsing fails.
    """
    try:
        # Find the start of the JSON object (assuming it's enclosed in curly braces)
        start_index = cohere_output.find('{')
        if start_index == -1:
            return None  # No JSON found

        # Extract the JSON string
        json_string = cohere_output[start_index:]

        # Load the JSON string into a Python dictionary
        data = json.loads(json_string)
        return data

    except json.JSONDecodeError:
        return None  # Invalid JSON

    except Exception as e:
        print(f"An error occurred: {e}")
        return None #other error

@userRouter.post("/upload-audio", response_model=ResponseObject)
async def upload_audio(file: UploadFile = File(...)):
    try:
        # Generate a unique filename
        file_extension = os.path.splitext(file.filename)[1]
        unique_filename = f"{uuid.uuid4()}{file_extension}"
        file_path = f"uploads/{unique_filename}"  # Store in an 'uploads' directory

        # Create the 'uploads' directory if it doesn't exist
        os.makedirs("uploads", exist_ok=True)

        # Save the audio file
        with open(file_path, "wb") as buffer:
            buffer.write(await file.read())

        # --- Whisper "tiny" model integration ---
        device = "cuda:0" if torch.cuda.is_available() else "cpu"
        torch_dtype = torch.float16 if torch.cuda.is_available() else torch.float32

        processor = WhisperProcessor.from_pretrained("openai/whisper-tiny")
        model = WhisperForConditionalGeneration.from_pretrained("openai/whisper-tiny")
        model.to(device)  # Move model to GPU if available

        # Load and process the audio
        audio_array, sampling_rate = librosa.load(file_path, sr=16000)  # Load at 16kHz
        input_features = processor(audio_array, sampling_rate=sampling_rate, return_tensors="pt").input_features.to(device) #Move input to GPU if available

        # Generate transcription
        predicted_ids = model.generate(input_features)
        transcription = processor.batch_decode(predicted_ids, skip_special_tokens=True)[0]  # Get the first (and only) transcription

        print("Transcription:", transcription)
        prompt = f"""
                    You are an intelligent assistant designed to understand user commands and translate them into structured JSON output.

                    You are given a user command from a voice assistant. Your task is to:

                    1. Identify the device being referred to in the command. The device must be one of the following: thermostat, smart light, smart lock, refrigerator, socket, camera.
                    2. Determine the specific command the user wants to execute on that device.
                    3. Return the output as a JSON object with the following format:

                    {{
                    "device": "device_name",
                    "command": "device_command"
                    }}

                    Device Commands:
                    - thermostat: turn_on (plug_in), turn_off (plug_out)
                    - smart light: turn_on (turn_in), turn_off (turn_off)
                    - smart lock: plug_in (plug_in), unplug (unplug)
                    - refrigerator: plug_in (plug_in), unplug (plug_out)
                    - socket: plug_in (plug_in), unplug (unplug)
                    - camera: plug_in (plug_in), plug_out (plug_out)

                    Note:
                    - "light" is an alias for "smart light".
                    - "lock" is an alias for "smart lock".
                    - "fridge" is an alias for "refrigerator".
                    - "outlet" is an alias for "socket".
                    - If the command is to turn something on, or plug something in, the command will be "plug_in".
                    - If the command is to turn something off, or unplug something, the command will be "plug_out".
                    - If the transcription is vague, deduce the closest device from the list.
                    - If the transcription is vague, and the device is unclear, return a json object with an error message in the command section.

                    Here are some examples:
                    User: "Turn on the thermostat"
                    Output: {{ "device": "thermostat", "command": "plug_in" }}

                    User: "Turn off the thermostat"
                    Output: {{ "device": "thermostat", "command": "plug_out" }}

                    User: "Turn on the light"
                    Output: {{ "device": "smart light", "command": "turn_on" }}

                    User: "Turn off the light"
                    Output: {{ "device": "smart light", "command": "turn_off" }}

                    User: "Unplug the refrigerator"
                    Output: {{ "device": "refrigerator", "command": "unplug" }}

                    User: "plug in the camera"
                    Output: {{ "device": "camera", "command": "plug_in" }}

                    User: "open the lock"
                    Output: {{ "device": "smart lock", "command": "plug_in" }}

                    User: "open the door"
                    Output: {{ "device": "smart lock", "command": "unlock" }}

                    User: "unlock the door"
                    Output: {{ "device": "smart lock", "command": "unlock" }}

                    User: "close the lock"
                    Output: {{ "device": "smart lock", "command": "unplug" }}

                    User: "turn the fridge off"
                    Output: {{ "device": "refrigerator", "command": "unplug" }}

                    User: "bad input"
                    Output: {{ "device": "unknown", "command": "Could not identify device" }}

                    User: "turn on the bad input device"
                    Output: {{ "device": "unknown", "command": "Could not identify device" }}

                    Now, process the following user command:

                    User: "{transcription}"
                    Output:
                    """
        device = use_llm(prompt)
        print(device)
        device = parse_cohere_output(device)
        if device['device'] == 'thermostat': 
            print('jiiii')
            await send_command('677ff0c3dc28041eb6f226eb', device['command'])
        elif device['device'] == 'smart light': 
            print('jiiii')
            await send_command('677ff0c3dc28041eb6f226ec', device['command'])
        elif device['device'] == 'smart lock': 
            print('jiiii')
            await send_command('677ff0c3dc28041eb6f226ee', device['command'])
        elif device['device'] == 'camera': 
            print('jiiii')
            await send_command('677ff0c3dc28041eb6f226ed', device['command'])
        elif device['device'] == 'refrigerator': 
            print('jiiii')
            await send_command('67af7cfc24953794d7ac704a', device['command'])

        response_info = ResponseInfo(
            statusCode=200, message="Success", detail="Audio uploaded and processed."
        )
        return ResponseObject(data={"file_path": file_path, "transcription": transcription}, statusCode=200, responseInfo=response_info)

    except Exception as e:
        print(f"Error uploading audio: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=500, detail="Failed to upload audio.")