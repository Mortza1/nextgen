import React, { useEffect, useState } from "react";
import styles from '../styles.module.css';
import { getHomeUsers, sendInvite } from "@app/api/actions";
import { getUserId } from "@app/services/auth";

interface HomeDetailsProps {
  home: any; // Receive the home object as a prop
  onBackClick: () => void; // Function to handle back navigation
}

const HomeDetails: React.FC<HomeDetailsProps> = ({ home, onBackClick }) => {
  const [showInviteField, setShowInviteField] = useState(false);
  const [inviteEmail, setInviteEmail] = useState("");
  const [dwellers, setDwellers] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const fetchDwellers = async () => {
      try {
        if (home.dwellers && home.dwellers.length > 0) {
          // Extract user_id from each dweller object
          const userIds = home.dwellers.map((dweller: any) => dweller.user_id);
    
          // Fetch dwellers data
          const dwellersData = await getHomeUsers({ user_ids: userIds });
    
          // Merge status from home.dwellers into the received users
          const enrichedDwellers = dwellersData['users'].map((user: any) => {
            const matchingDweller = home.dwellers.find(
              (dweller: any) => dweller.user_id === user._id
            );
            return {
              ...user,
              status: matchingDweller ? matchingDweller.status : "unknown", // Default to "unknown" if no match
            };
          });
    
          setDwellers(enrichedDwellers);
          console.log("Dwellers with status:", enrichedDwellers);
        }
      } catch (error) {
        console.error("Error fetching dwellers:", error);
      }
    };
    

    fetchDwellers();
  }, [home.dwellers]);

  const handleInviteClick = () => {
    setShowInviteField((prev) => !prev);
  };

  const handleEmailChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInviteEmail(event.target.value);
  };

  const handleInviteSubmit = async () => {
    // Check if the inviteEmail already exists in the dwellers
    const isEmailExisting = dwellers.some((dweller) => dweller.email === inviteEmail);

    if (isEmailExisting || inviteEmail == '') {
      alert("This email is already a dweller.");
      setInviteEmail(""); // Reset invite email input
      return; // Exit if the email is already a dweller
    }

    try {
      await sendInvite({ email: inviteEmail, house_id: home._id, manager_id: getUserId() });
      console.log("Inviting:", inviteEmail);
    } catch (error) {
      console.error("Error sending invite:", error);
    } finally {
      setIsLoading(false); // Stop loader
      setInviteEmail(""); // Reset invite email input
      setShowInviteField(false); // Optionally close the invite field after submission
    }
  };

  return (
    <div className={styles.homeDetails}>
      <div className={styles.top}>
        <div className={styles.back} onClick={onBackClick}>
          <img src="back.png" alt="" height={15} />
        </div>
        <div className={styles.homeName}>{home.name}</div>
      </div>

      <div className={styles.dwellers}>
        <div className={styles.dwellersTop}>
          <div>Dwellers</div>
          <div className={styles.dwellersActions}>
            <div className={styles.button} onClick={handleInviteClick}>Invite</div>
            <div className={styles.button}>Remove</div>
          </div>
        </div>

        {showInviteField && (
          <div className={styles.inviteField}>
            <input
              type="email"
              value={inviteEmail}
              onChange={handleEmailChange}
              disabled={isLoading}
              placeholder="Enter dweller's email"
              className={styles.input}
            />
            <button onClick={handleInviteSubmit} className={styles.submitButton}>
            {isLoading? <div className={styles.loader}></div> : 'Send email' }
            </button>
          </div>
        )}

        {dwellers && dwellers.length > 0 ? (
          dwellers.map((dweller: any, index: number) => (
            <div
              key={index}
              className={`${styles.dwellerItem} ${
                index % 2 === 0 ? styles.even : styles.odd
              }`}
            >
              {dweller.status === 'invited' ? (<div className={styles.dwellerItem}>
                <div className={styles.dwellerField}>{dweller.email}</div>
                <div className={styles.dwellerFieldStatus}><div className={styles.dwellerFieldStatus}>{dweller.status}</div></div>
                 </div>) : (<div className={styles.dwellerItem}><div className={styles.dwellerField}>{dweller.status}</div>
                <div className={styles.dwellerField}>{dweller.email}</div> </div>)}
            </div>
          ))
        ) : (
          <div className={`${styles.dwellerItem} ${styles.even}`}>
            <div className={styles.dwellerField}>No dwellers</div>
          </div>
        )}
      </div>
    </div>
  );
};

export default HomeDetails;
