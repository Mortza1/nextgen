import React from "react";
import styles from "../styles.module.css";
import Stats from "./Stats"; // Import your Stats component

const DashboardScreen: React.FC = () => {
  return (
    <div className={styles.content}>
          <div className={styles.top}>
              <div className={styles.left}>
                  <div className={styles.top}>
                      <div className={styles.leftTop}></div>
                      <div className={styles.rightTop}></div>
                  </div>
                  <div className={styles.bottom}></div>
              </div>
              <div className={styles.right}></div>
            </div>
          <div className={styles.bottom}>
              <div className={styles.music}>music</div>
              <div className={styles.graph}>graph</div>
          </div>  
    </div>
  );
};

export default DashboardScreen;
