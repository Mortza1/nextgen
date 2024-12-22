import { memo, useState } from "react";
import styles from "./styles.module.css";
import { DotLottieReact } from "@lottiefiles/dotlottie-react";
import AddHomeForm from "./components/AddHomeForm";

const Homes: React.FC = () => {
  const [isAddingHome, setIsAddingHome] = useState(false);

  const handleAddHomeClick = () => {
    setIsAddingHome(true);
  };

  const handleCancelClick = () => {
    setIsAddingHome(false);
  };

  return (
    <div className={styles.main}>
          <div className={styles.add_home_row}>
            <div className={styles.heading}>Homes</div>
            <div className={styles.button} onClick={handleAddHomeClick}>
              Add Home +
            </div>
          </div>
          {!isAddingHome ? (
          <div className={styles.homes}>
            <DotLottieReact
              src="https://lottie.host/a3472677-7d54-48eb-95c0-730b7a7be56b/FyUW2IUG1h.lottie"
              loop
              autoplay
              style={{ width: "70%", height: "70%" }}
            />
            <div className={styles.text}>Add a home</div>
          </div>
        
      ) : (
        // Add Home Form View
        <AddHomeForm onCancel={handleCancelClick} devices={[]} dwellers={[]} />
      )}
    </div>
  );
};

export default memo(Homes);
