import { memo, useState } from "react";
import styles from "./styles.module.css";
import { FaSearch } from "react-icons/fa";
import { CiFilter } from "react-icons/ci";
import { BsThreeDots } from "react-icons/bs";

// Define the Device type
interface Device {
  _id: string;
  name: string;
  type: string;
  current_data: any;
  historical_data: any; // Replace `any` with the actual structure if known
  home_id: string;
}

// Props for the Devices component
interface DevicesProps {
  devices: Device[]; // Pass devices data as a prop
}

const Devices: React.FC<DevicesProps> = ({ devices }) => {
  const [selectedTab, setSelectedTab] = useState<string>("All");
  const [isDialogOpen, setIsDialogOpen] = useState<boolean>(false);

  const handleOpenDialog = () => {
    setIsDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setIsDialogOpen(false);
  };

  const handleTabClick = (tab: string) => {
    setSelectedTab(tab); // Update selected tab
  };

  return (
    <div className={styles.main}>
      <div className={styles.top}>
        <div className={styles.title}>My Devices</div>
        <div className={styles.inputContainer}>
          <input
            className={styles.inputField}
            type="text"
            placeholder="Search for devices"
          />
          <span className={styles.suffixIcon}>
            <FaSearch size={16} />
          </span>
        </div>
      </div>

      {/* Tabs Section */}
      <div className={styles.tabs}>
        <div
          className={`${styles.tabItem} ${selectedTab === "All" ? styles.selectedTab : ""}`}
          onClick={() => handleTabClick("All")}
        >
          All
        </div>
        <div
          className={`${styles.tabItem} ${selectedTab === "Living Room" ? styles.selectedTab : ""}`}
          onClick={() => handleTabClick("Living Room")}
        >
          Living Room
        </div>
        <div
          className={`${styles.tabItem} ${selectedTab === "Bedroom" ? styles.selectedTab : ""}`}
          onClick={() => handleTabClick("Bedroom")}
        >
          Bedroom
        </div>
        <div
          className={`${styles.tabItem} ${selectedTab === "Kitchen" ? styles.selectedTab : ""}`}
          onClick={() => handleTabClick("Kitchen")}
        >
          Kitchen
        </div>
      </div>
      <div className={styles.divider} />

      {/* Table Header */}
      <div className={styles.tableHeader}>
        <div className={styles.tableHeaderItem}>Name</div>
        <div className={styles.tableHeaderItem}>Type</div>
        <div className={styles.tableHeaderItem}>Status</div>
        <div className={styles.tableHeaderItem}>
          <CiFilter />
        </div>
      </div>
      <div className={styles.blackDivider} />

      {/* Table Rows */}
      {devices.length > 0 ? (
        devices.map((device) => (
          <div key={device._id}>
            <div className={styles.tableRow}>
              <div className={styles.tableRowItem}>{device.name}</div>
              <div className={styles.tableRowItem}>{device.type}</div>
              <div className={styles.tableRowItem}>
                {device.current_data ? "ON" : "OFF"} {/* Example status logic */}
              </div>
              <div className={styles.tableRowItem}>
                <BsThreeDots />
              </div>
            </div>
            <div className={styles.blackDivider} />
          </div>
        ))
      ) : (
        <p>No devices found.</p>
      )}

      {/* Add Device Button */}
      <div className={styles.addDeviceButton} onClick={handleOpenDialog}>
        Add Device +
      </div>

      {/* Dialog Modal */}
      {isDialogOpen && (
        <div className={styles.dialogOverlay}>
          <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
            <div>Add Device</div>
            <div className={styles.inputContainer}>
              <input
                className={styles.inputField}
                type="text"
                placeholder="Set device name"
              />
            </div>
            <button onClick={handleCloseDialog} className={styles.closeButton}>
              Close
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default memo(Devices);