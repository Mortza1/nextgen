import React from "react";
import styles from "../styles.module.css";

interface TopNavProps {
  onSelect: (screen: string) => void;
}

const TopNav: React.FC<TopNavProps> = ({ onSelect }) => {
  const handleNavigation = (screen: string) => {
    onSelect(screen);
  };

  return (
    <div className={styles.topNav}>
      <div className={styles.logo}>
        <img src="bulb.png" alt="Logo" height={30} />
        <div>NexGen</div>
      </div>
      <div className={styles.navItems}>
        <div
          className={styles.item}
          onClick={() => handleNavigation("DASHBOARD")}
        >
          DASHBOARD
        </div>
        <div
          className={styles.item}
          onClick={() => handleNavigation("HOMES")}
        >
          HOMES
        </div>
        <div
          className={styles.item}
          onClick={() => handleNavigation("DWELLERS")}
        >
          DWELLERS
        </div>
      </div>
      <div>temp</div>
    </div>
  );
};

export default TopNav;
