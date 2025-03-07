import httpx
import asyncio

async def daily_usage(hub_id: str):
    """
    Runs on schedule to find daily usage of data for all users and devices and saves them in the database.
    """
    try:
        async with httpx.AsyncClient() as client:
            # Fetch data from the API endpoint
            response = await client.get(f"http://localhost:8010/devices/today/{hub_id}")
            
            if response.status_code == 200:
                # Parse and handle the data
                data = response.json()
                print(data[0])
                  
            else:
                print(f"Failed to fetch data, status code: {response.status_code}")
                
    except Exception as e:
        print(f"An error occurred: {e}")

# Ensure the function is called with asyncio.run
if __name__ == "__main__":
    asyncio.run(daily_usage('677fee2c8c977bf4be7f1377'))
