import React from "react";
import Select from "react-select";
import styles from "../styles.module.css";

interface DeviceSelectorProps {
  devices: string[];
  selectedDevices: string[];
  onChange: (selected: string[]) => void;
}

const DeviceSelector: React.FC<DeviceSelectorProps> = ({
  devices,
  selectedDevices,
  onChange,
}) => {
  const options = devices.map((device) => ({ value: device, label: device }));

  const handleChange = (selectedOptions: any) => {
    const selectedValues = selectedOptions.map((option: any) => option.value);
    onChange(selectedValues);
  };

  return (
    <div className={styles.form_group}>
      <label htmlFor="devices">Select Devices:</label>
      <Select
        id="devices"
        options={options}
        isMulti
        value={options.filter((option) => selectedDevices.includes(option.value))}
        onChange={handleChange}
        placeholder="Select devices..."
        className={styles.custom_select}
      />
    </div>
  );
};

export default DeviceSelector;
