import React from "react";
import styles from "../styles.module.css";
import Stats from "./Stats"; // Import your Stats component

const DashboardScreen: React.FC = () => {
  return (
    <div className={styles.content}>
      <img src="dashboard.png" alt="" height={550} />
    </div>
  );
};

export default DashboardScreen;
