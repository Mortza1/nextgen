import React, { useState } from "react";
import styles from "../styles.module.css";
import DeviceSelector from "./DeviceSelector";  // Import the DeviceSelector component

interface AddHomeFormProps {
  onCancel: () => void;
  devices: string[]; // List of devices available in the system
  dwellers: string[]; // List of dwellers available in the system
}

const AddHomeForm: React.FC<AddHomeFormProps> = ({ onCancel, devices, dwellers }) => {
  const [formValues, setFormValues] = useState({
    homeName: "",
    homeAddress: "",
    selectedDevices: [] as string[], // Array to store selected devices
    selectedDwellers: [] as string[], // Array to store selected dwellers
  });

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    setFormValues((prevValues) => ({
      ...prevValues,
      [name]: value,
    }));
  };

  const handleDeviceSelectChange = (selectedDevices: string[]) => {
    setFormValues((prevValues) => ({
      ...prevValues,
      selectedDevices,
    }));
  };

  const handleDwellersSelectChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
    const options = Array.from(event.target.selectedOptions, (option) => option.value);
    setFormValues((prevValues) => ({
      ...prevValues,
      selectedDwellers: options,
    }));
  };

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    console.log("Form submitted with values:", formValues);
    // Add form submission logic here
  };

  return (
    <div className={styles.add_home_form}>
      <form onSubmit={handleSubmit}>
        <div className={styles.form_group}>
          <label htmlFor="homeName">Home Name:</label>
          <input
            type="text"
            id="homeName"
            name="homeName"
            value={formValues.homeName}
            onChange={handleInputChange}
            placeholder="Enter home name"
          />
        </div>
        <div className={styles.form_group}>
          <label htmlFor="homeAddress">Address:</label>
          <input
            type="text"
            id="homeAddress"
            name="homeAddress"
            value={formValues.homeAddress}
            onChange={handleInputChange}
            placeholder="Enter address"
          />
        </div>

        {/* Device Selector */}
        <DeviceSelector
          devices={devices}
          selectedDevices={formValues.selectedDevices}
          onChange={handleDeviceSelectChange}
        />
        <div className={styles.form_actions}>
          <button
            type="button"
            className={styles.cancel_button}
            onClick={onCancel}
          >
            Cancel
          </button>
          <button type="submit" className={styles.submit_button}>
            Submit
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddHomeForm;
