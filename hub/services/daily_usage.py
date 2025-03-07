import os
import json
from datetime import datetime
from fastapi import HTTPException

def log_hourly_energy_usage():
    # Define the base path for device data
    base_path = os.path.join(os.path.dirname(__file__), "..", "device_data")

    # Check if the folder exists
    if not os.path.exists(base_path):
        raise HTTPException(status_code=404, detail="Device data folder not found")

    # Get all JSON files in the device_data folder
    device_files = [f for f in os.listdir(base_path) if f.endswith(".json")]

    if not device_files:
        raise HTTPException(status_code=404, detail="No device files found")

    today_date = datetime.now().strftime("%Y-%m-%d")  # Current date in YYYY-MM-DD format
    hourly_energy_usage = {}

    # Process each device file
    for file_name in device_files:
        file_path = os.path.join(base_path, file_name)

        with open(file_path, "r") as file:
            data = json.load(file)  # Load JSON data from file

        device_hourly_usage = {}

        # Process each log entry
        for entry in data:
            timestamp = entry.get("timestamp")
            device_id = entry.get("device_id")
            power_consumption = entry.get("metric", {}).get("power_consumption", 0)

            if not timestamp or device_id is None:
                continue  # Skip invalid entries

            entry_date, entry_time = timestamp.split(" ")  # Extract date and time
            if entry_date != today_date:
                continue  # Only process today's data

            hour = entry_time.split(":")[0]  # Extract hour from time

            if device_id not in device_hourly_usage:
                device_hourly_usage[device_id] = {}

            if hour not in device_hourly_usage[device_id]:
                device_hourly_usage[device_id][hour] = {
                    "first": power_consumption,
                    "last": power_consumption
                }
            else:
                device_hourly_usage[device_id][hour]["last"] = power_consumption

        # Calculate hourly usage for this device
        for device_id, hourly_data in device_hourly_usage.items():
            if device_id not in hourly_energy_usage:
                hourly_energy_usage[device_id] = {str(h).zfill(2): 0 for h in range(24)}

            for hour, values in hourly_data.items():
                hourly_usage = round(values["last"] - values["first"], 2)
                hourly_energy_usage[device_id][hour] += max(hourly_usage, 0)  # Ensure non-negative usage

    log_file_path = os.path.join(os.path.dirname(__file__), "hourly_energy_log.txt")

    # Log energy usage into a text file
    with open(log_file_path, "w") as log_file:
        log_file.write(f"Energy usage for {today_date}:\n")
        for device_id, usage in hourly_energy_usage.items():
            log_file.write(f"\nDevice: {device_id}\n")
            for hour, energy in sorted(usage.items()):
                log_file.write(f"{hour}:00 - {energy} kWh\n")
        log_file.write("\n")

    return hourly_energy_usage


# Run the function
log_hourly_energy_usage()
