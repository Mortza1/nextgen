import { memo, useState } from "react";
import styles from "./styles.module.css";
import { FaSearch } from "react-icons/fa";
import { CiFilter } from "react-icons/ci";
import { BsThreeDots } from "react-icons/bs";

const Notifications: React.FC = () => {
  return (
    <div className={styles.main}>
      <div className={styles.top}>
        <div className={styles.title}>Notifications</div>
      </div>
          <div className={styles.notificationBox}>
              <div className={styles.card}></div>
              <div className={styles.card}></div>
              <div className={styles.card}></div>
              <div className={styles.card}></div>
              <div className={styles.card}></div>
          </div>
        
        <div className={styles.loadMore}>Load More</div>
      
    </div>
  );
};

export default memo(Notifications);
