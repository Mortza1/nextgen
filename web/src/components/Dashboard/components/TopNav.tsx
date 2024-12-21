import React from 'react';
import styles from '../styles.module.css'; // Create a separate CSS file for this component

const TopNav: React.FC = () => {
  return (
    <div className={styles.topNav}>
      <div className={styles.logo}>
              <img src="bulb.png" alt="Logo" height={30} />
              <div>NexGen</div>
      </div>
      <div className={styles.navItems}>
        <div className={styles.item}>DASHBOARD</div>
        <div className={styles.item}>HOMES</div>
        <div className={styles.item}>DWELLERS</div>
      </div>
      <div>temp</div>
    </div>
  );
};

export default TopNav;
