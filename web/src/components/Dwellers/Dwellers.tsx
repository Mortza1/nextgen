import { memo, useState, useEffect } from "react";
import styles from "./styles.module.css";
import { FaSearch } from "react-icons/fa";
import { sendInvite } from "@app/api/actions";

// Define the Dweller type
interface Dweller {
  _id: string;
  name: string;
  email: string;
  role: string;
  managed_homes: any[]; // Update this type if you have a specific structure
}

// Props for the Dwellers component
interface DwellersProps {
  dwellers: Dweller[];
  manager_id: string;
  house_id: string;
}

const Dwellers: React.FC<DwellersProps> = ({ dwellers, manager_id, house_id }) => {
  const [isDialogOpen, setIsDialogOpen] = useState<boolean>(false);
  const [email, setEmail] = useState<string>(""); // State to store the email input

  const handleOpenDialog = () => {
    setIsDialogOpen(true);
  };

  const handleCloseDialog = () => {
    setIsDialogOpen(false);
  };

  const handleSendInvite = () => {
    if (!email) {
      alert("Please enter an email address.");
      return;
    }

    sendInvite({ manager_id, house_id, email }); // Call the sendInvite API

    // Reset the email input and close the dialog
    setEmail("");
    handleCloseDialog();
  };

  // Close the dialog when clicking outside
  useEffect(() => {
    const handleOutsideClick = (e: MouseEvent) => {
      const dialog = document.querySelector(`.${styles.dialog}`);
      const overlay = document.querySelector(`.${styles.dialogOverlay}`);

      if (isDialogOpen && overlay && dialog && !dialog.contains(e.target as Node)) {
        handleCloseDialog();
      }
    };

    if (isDialogOpen) {
      document.addEventListener("mousedown", handleOutsideClick);
    }

    return () => {
      document.removeEventListener("mousedown", handleOutsideClick);
    };
  }, [isDialogOpen]);

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
        {dwellers.length > 0 ? (
          dwellers.map((dweller) => (
            <div key={dweller._id} className={styles.card}>
              <div className={styles.cardContent}>
                <img src="boy.png" alt="" height={50} />
                <div className={styles.text}>
                  <h3>{dweller.name}</h3>
                  <p>{dweller.email}</p>
                </div>
              </div>
            </div>
          ))
        ) : (
          <p>No dwellers found.</p>
        )}
      </div>

      {/* Add Device Button */}
      <div className={styles.addDeviceButton} onClick={handleOpenDialog}>
        Add Dweller +
      </div>

      {/* Dialog Modal */}
      {isDialogOpen && (
        <div className={styles.dialogOverlay}>
          <div className={styles.dialog} onClick={(e) => e.stopPropagation()}>
            <div>Invite</div>
            <div className={styles.inputContainer}>
              <input
                className={styles.inputField}
                type="email" // Use type="email" for better validation
                placeholder="Dweller email address"
                value={email}
                onChange={(e) => setEmail(e.target.value)} // Update the email state
              />
            </div>
            <button onClick={handleSendInvite} className={styles.closeButton}>
              Send Invite
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default memo(Dwellers);