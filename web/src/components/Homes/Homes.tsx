import { memo, useState, useEffect } from "react";
import styles from "./styles.module.css";
import { DotLottieReact } from "@lottiefiles/dotlottie-react";
import AddHomeForm from "./components/AddHomeForm";
import { getHomes } from "@app/api/actions";
import { getUserId } from "@app/services/auth";
import HomeDetails from "./components/HomeDetails";

const Homes: React.FC = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [isAddingHome, setIsAddingHome] = useState(false);
  const [homes, setHomes] = useState<any[]>([]); 
  const [selectedHome, setSelectedHome] = useState<any | null>(null); 

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
          {selectedHome ? `Home detail page` : "Homes"}
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
            <HomeDetails home={selectedHome} onBackClick={handleBackClick}/>
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
                <div className={styles.home_name}>#{index+1}. {home.name}</div>
              </div>
            ))
          )}
        </div>
      )}
    </div>
  );
};

export default memo(Homes);
