import { memo, useState } from "react";
import styles from "./styles.module.css";
import { FaSearch } from "react-icons/fa";
import { CiFilter } from "react-icons/ci";
import { BsThreeDots } from "react-icons/bs";

const Dwellers: React.FC = () => {
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
        <div className={styles.title}>Dwellers</div>
        <div className={styles.inputContainer}>
          <input
            className={styles.inputField}
            type="text"
            placeholder="Search for dwellers"
          />
          <span className={styles.suffixIcon}>
            <FaSearch size={16} />
          </span>
        </div>
          </div>
          
        {/* Grid Container */}
        <div className={styles.gridContainer}>
        {/* 6 Empty Cards */}
        <div className={styles.card}></div>
        <div className={styles.card}></div>
        <div className={styles.card}></div>
        <div className={styles.card}></div>
        <div className={styles.card}></div>
        <div className={styles.card}></div>
        </div>
    
      {/* Add Device Button */}
      <div className={styles.addDeviceButton} onClick={handleOpenDialog}>
        Add Dweller +
      </div>

      {/* Dialog Modal */}
      {isDialogOpen && (
        <div className={styles.dialogOverlay}>
          <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
            <div>Add Dweller</div>
            <div className={styles.inputContainer}>
            <input
              className={styles.inputField}
              type="text"
              placeholder="Set dweller name"
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

export default memo(Dwellers);
