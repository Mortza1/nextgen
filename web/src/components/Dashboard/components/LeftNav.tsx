import React, { useState } from 'react';
import styles from '../styles.module.css';

interface NavItem {
    id: string; // Unique identifier
  icon: string; // Icon source
  text: string; // Display text
}

const navItems: NavItem[] = [
  { id: 'report1', icon: 'report-w.png', text: 'Monitoring' },
  { id: 'report2', icon: 'bell-w.png', text: 'Notifications' },
  { id: 'report3', icon: 'settings-w.png', text: 'Settings' },
];

const LeftNav = () => {
  const [activeItem, setActiveItem] = useState<string | null>(null);

  const handleClick = (id: string) => {
    setActiveItem(id);
  };

  return (
    <div className={styles.leftNav}>
      {navItems.map((item) => (
        <div
          key={item.id}
          className={`${styles.item} ${activeItem === item.id ? styles.active : ''}`}
          onClick={() => handleClick(item.id)}
        >
          <div className={styles.icon}>
            <img src={item.icon} alt="" height={20} />
          </div>
          <div className={styles.subtext}>{item.text}</div>
        </div>
      ))}
    </div>
  );
};

export default LeftNav;
