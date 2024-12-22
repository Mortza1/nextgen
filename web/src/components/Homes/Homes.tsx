import { memo, useState, useEffect } from "react";
import styles from "./styles.module.css";
import { DotLottieReact } from "@lottiefiles/dotlottie-react";
import AddHomeForm from "./components/AddHomeForm";
import { getHomes } from "@app/api/actions";
import { getUserId } from "@app/services/auth";

const Homes: React.FC = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [isAddingHome, setIsAddingHome] = useState(false);
  const [homes, setHomes] = useState<any[]>([]); // State to store the list of homes
  const [selectedHome, setSelectedHome] = useState<any | null>(null); // Track selected home

  useEffect(() => {
    setIsLoading(true);
    const fetchHomes = async () => {
      const fetchedHomes = await getHomes({ manager_id: getUserId() });
      if (fetchedHomes) {
        setHomes(fetchedHomes["homes"]);
      }
      setIsLoading(false);
    };
    fetchHomes();
  }, []);

  const handleAddHomeClick = () => {
    setIsAddingHome(true);
  };

  const handleCancelClick = () => {
    setIsAddingHome(false);
  };

  const handleHomeClick = (home: any) => {
    setSelectedHome(home); // Set the clicked home as the selected home
  };

  const handleBackClick = () => {
    setSelectedHome(null); // Clear the selected home to go back to the list
  };

  return (
    <div className={styles.main}>
      <div className={styles.add_home_row}>
        <div className={styles.heading}>
          {selectedHome ? `Home Details - ${selectedHome.name}` : "Homes"}
        </div>
        {!selectedHome && (
          <div className={styles.button} onClick={handleAddHomeClick}>
            Add Home +
          </div>
        )}
      </div>

      {isLoading ? (
        <div className={styles.loader}></div>
      ) : isAddingHome ? (
        <AddHomeForm onCancel={handleCancelClick} devices={[]} dwellers={[]} />
      ) : selectedHome ? (
        // Home Details View
        <div className={styles.homeDetails}>
          <button className={styles.backButton} onClick={handleBackClick}>
            Back
          </button>
          <h2 className={styles.homeName}>{selectedHome.name}</h2>
          <p className={styles.homeAddress}>{selectedHome.address}</p>
          <div>
            <h3>Dwellers:</h3>
            <ul>
              {selectedHome.dwellers?.map((dweller: any, index: number) => (
                <li key={index}>{dweller.name}</li>
              ))}
            </ul>
          </div>
          <div>
            <h3>Devices:</h3>
            <ul>
              {selectedHome.devices?.map((device: any, index: number) => (
                <li key={index}>{device.name}</li>
              ))}
            </ul>
          </div>
        </div>
      ) : (
        // Homes List View
        <div className={styles.homes}>
          {homes.length === 0 ? (
            <>
              <DotLottieReact
                src="https://lottie.host/a3472677-7d54-48eb-95c0-730b7a7be56b/FyUW2IUG1h.lottie"
                loop
                autoplay
                style={{ width: "70%", height: "70%" }}
              />
              <div className={styles.text}>Add a home</div>
            </>
          ) : (
            homes.map((home, index) => (
              <div
                key={index}
                className={styles.home}
                onClick={() => handleHomeClick(home)} // Navigate to home details on click
              >
                <div className={styles.home_name}>{home.name}</div>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
};

export default memo(Homes);
