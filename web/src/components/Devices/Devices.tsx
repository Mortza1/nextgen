import { memo, useState } from "react";
import styles from "./styles.module.css";
import { FaSearch } from "react-icons/fa";
import { CiFilter } from "react-icons/ci";
import { BsThreeDots } from "react-icons/bs";

const Devices: React.FC = () => {
  // State to keep track of the selected tab
  const [selectedTab, setSelectedTab] = useState<string>('All'); 
  const [isDialogOpen, setIsDialogOpen] = useState<boolean>(false);
  const handleOpenDialog = () => {
    setIsDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setIsDialogOpen(false);
  };

  // Function to handle tab selection
  const handleTabClick = (tab: string) => {
    setSelectedTab(tab);  // Update selected tab
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
          className={`${styles.tabItem} ${selectedTab === 'All' ? styles.selectedTab : ''}`}
          onClick={() => handleTabClick('All')}
        >
          All
        </div>
        <div
          className={`${styles.tabItem} ${selectedTab === 'Living Room' ? styles.selectedTab : ''}`}
          onClick={() => handleTabClick('Living Room')}
        >
          Living Room
        </div>
        <div
          className={`${styles.tabItem} ${selectedTab === 'Bedroom' ? styles.selectedTab : ''}`}
          onClick={() => handleTabClick('Bedroom')}
        >
          Bedroom
        </div>
        <div
          className={`${styles.tabItem} ${selectedTab === 'Kitchen' ? styles.selectedTab : ''}`}
          onClick={() => handleTabClick('Kitchen')}
        >
          Kitchen
        </div>
      </div>
      <div className={styles.divider} />
      <div className={styles.tableHeader}>
        <div className={styles.tableHeaderItem}>Name</div>
        <div className={styles.tableHeaderItem}>Type</div>
        <div className={styles.tableHeaderItem}>Status</div>
        <div className={styles.tableHeaderItem}><CiFilter /></div>
      </div>
      <div className={styles.blackDivider}></div>
      <div className={styles.tableRow}>
          <div className={styles.tableRowItem}>Living Room Chandelier</div>
          <div className={styles.tableRowItem}>Lights</div>
          <div className={styles.tableRowItem}>ON</div>
          <div className={styles.tableRowItem}><BsThreeDots /></div>
      </div>
      <div className={styles.blackDivider}></div>

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
