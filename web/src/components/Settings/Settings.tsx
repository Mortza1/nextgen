import { memo, useState } from "react";
import styles from "./styles.module.css";

const Settings: React.FC = () => {
    const [isDialogOpen, setIsDialogOpen] = useState<boolean>(false);
    const handleOpenDialog = () => {
        setIsDialogOpen(true);
    };

    const handleCloseDialog = () => {
        setIsDialogOpen(false);
    };
  return (
    <div className={styles.main}>
      <div className={styles.top}>
        <div className={styles.title}>Settings</div>
          </div>
          
          <div className={styles.manageHomeContainer}>
              <div className={styles.text}>Manage Homes</div>
              <div className={styles.manageHomeBox}>
                  <div>Home</div>
                  <div className={styles.home}></div>
                  <div className={styles.add} onClick={handleOpenDialog}>+</div>
              </div>
          </div>

          <div className={styles.manageRoomContainer}>
              <div className={styles.text}>Add Rooms</div>
              <div className={styles.manageRoomBox}>
                  <div>Rooms</div>
                  <div className={styles.rooms}>
                    <div className={styles.home}></div>
                    <div className={styles.home}></div>
                    <div className={styles.home}></div>    
                  </div>
                  
                  <div className={styles.add} onClick={handleOpenDialog}>+</div>
              </div>
          </div>

          <div className={styles.devicesContainer}>
              <div>Add Devices</div>
              <div className={styles.add} onClick={handleOpenDialog}>+</div>
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

export default memo(Settings);
