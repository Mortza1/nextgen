import React from "react";
import styles from "../styles.module.css";

interface TopNavProps {
  onSelect: (screen: string) => void;
  selectedScreen: string; // Pass the selected screen as a prop
}

const TopNav: React.FC<TopNavProps> = ({ onSelect, selectedScreen }) => {
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
          className={`${styles.item} ${selectedScreen === "DASHBOARD" ? styles.selected : ""}`}
          onClick={() => handleNavigation("DASHBOARD")}
        >
          DASHBOARD
        </div>
        <div
          className={`${styles.item} ${selectedScreen === "HOMES" ? styles.selected : ""}`}
          onClick={() => handleNavigation("HOMES")}
        >
          HOMES
        </div>
        <div
          className={`${styles.item} ${selectedScreen === "DWELLERS" ? styles.selected : ""}`}
          onClick={() => handleNavigation("DWELLERS")}
        >
          DWELLERS
        </div>
        <div
          className={`${styles.item} ${selectedScreen === "DEVICES" ? styles.selected : ""}`}
          onClick={() => handleNavigation("DEVICES")}
        >
          DEVICES
        </div>
      </div>
      <div>temp</div>
    </div>
  );
};

export default TopNav;
