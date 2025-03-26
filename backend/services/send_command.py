import httpx
from fastapi import HTTPException
from model.deviceModel import ResponseObject

async def send_command(device_id, command): #Added async here.
    try:
        # Prepare the data for the external request
        url = f"http://localhost:8010/devices/{device_id}/command"
        headers = {"Content-Type": "application/json"}
        body = {
            "device_id": device_id,
            "command": command
        }

        # Send the POST request to the new endpoint
        async with httpx.AsyncClient() as client:
            response = await client.post(url, json=body, headers=headers)

        # Check the response status code and handle accordingly
        if response.status_code == 200:
            # Return the successful response with data
            response_info = {
                "statusCode": 200,
                "message": "Success",
                "detail": "Device command sent successfully."
            }
            return ResponseObject(
                data=True,  # Send back the response data from the external endpoint
                statusCode=200,
                responseInfo=response_info
            )
        else:
            raise HTTPException(status_code=response.status_code, detail="Failed to send command to the device")

    except Exception as e:
        print(f"Error in send_command: {e}")
        raise HTTPException(status_code=500, detail="Internal server error.")