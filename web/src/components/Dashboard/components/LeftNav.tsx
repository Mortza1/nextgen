import React from "react";
import styles from "../styles.module.css";
import { FaHome } from "react-icons/fa";
import { BsGraphUpArrow } from "react-icons/bs";
import { BiSolidDevices } from "react-icons/bi";
import { MdPeopleAlt, MdEnergySavingsLeaf } from "react-icons/md";
import { IoIosNotifications } from "react-icons/io";
import { IoMdSettings } from "react-icons/io";

interface LeftNavProps {
  setActiveScreen: (screen: string) => void; // Callback to update Dashboard
}

const navItems = [
  { id: "DASHBOARD", icon: <BsGraphUpArrow size={20} />, text: "Dashboard" },
  { id: "HOMES", icon: <FaHome size={20} />, text: "Homes" },
  { id: "DEVICES", icon: <BiSolidDevices size={20} />, text: "Devices" },
  { id: "DWELLERS", icon: <MdPeopleAlt size={20} />, text: "Dwellers" },
  { id: "MONITORING", icon: <MdEnergySavingsLeaf size={20} />, text: "Energy Monitoring" },
  { id: "NOTIFICATIONS", icon: <IoIosNotifications size={20} />, text: "Notifications" },
];

interface LeftNavProps {
  activeScreen: string;
  setActiveScreen: (screen: string) => void;
}

const LeftNav: React.FC<LeftNavProps> = ({ activeScreen, setActiveScreen }) => {
  return (
    <div className={styles.leftNav}>
      <div className={styles.logo}>
        <img src="logo.png" alt="Logo" />
      </div>

      <div className={styles.navList}>
        {navItems.map((item) => (
          <div
            key={item.id}
            className={`${styles.navItem} ${activeScreen === item.id ? styles.selected : ''}`}
            onClick={() => setActiveScreen(item.id)}
          >
            <span className={styles.navIcon} style={{ color: activeScreen === item.id ? '#9CAD88' : '#fff' }}>
              {item.icon}
            </span>
            <span className={styles.navText}>{item.text}</span>
          </div>
        ))}
      </div>

      <div
        className={`${styles.navItem} ${styles.bottomItem} ${activeScreen === "SETTINGS" ? styles.selected : ''}`}
        onClick={() => setActiveScreen("SETTINGS")}
      >
        <span className={styles.navIcon} style={{ color: activeScreen === "SETTINGS" ? '#9CAD88' : '#fff' }}>
          <IoMdSettings size={20} />
        </span>
        <span className={styles.navText}>Settings</span>
      </div>
    </div>
  );
};

export default LeftNav;
