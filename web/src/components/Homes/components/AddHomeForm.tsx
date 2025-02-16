import React, { useState } from "react";
import styles from "../styles.module.css";
import DeviceSelector from "./DeviceSelector"; // Import the DeviceSelector component
import { getUserId } from "@app/services/auth";
import { addHome } from "@app/api/actions";

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

  const [loading, setLoading] = useState(false); // Track loading state

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

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    
    setLoading(true); // Set loading to true when the form is submitted

    try {
      // Call the async API to add the home
      await addHome({
        home_name: formValues.homeName,
        address: formValues.homeAddress,
        manager_id: getUserId(),
      });
      
      console.log("Form submitted with values:", formValues);
      // You can handle any post-submission logic here (e.g., resetting form, showing success message)
    } catch (error) {
      console.error("Error submitting the form:", error);
      // Handle error (e.g., show error message)
    } finally {
      setLoading(false); // Set loading to false after the API call completes
    }
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
          <button
            type="submit"
            className={styles.submit_button}
            disabled={loading} // Disable the button while loading
          >
            {loading ? (
              <span className={styles.loader}></span> // Show a loader while loading
            ) : (
              "Submit"
            )}
          </button>
        </div>
      </form>
    </div>
  );
};

export default AddHomeForm;
