import React, { useState } from "react";
import styles from "./styles.module.css";

const Homes: React.FC = () => {
  const [bgImage, setBgImage] = useState<string>('/home_bg.png');
  const handleRoomClick = (room: string) => {
    let newBgImage = '';
    switch (room) {
      case 'living room':
        newBgImage = '/home_bg.png';
        break;
      case 'bedroom':
        newBgImage = '/bed_bg.png';
        break;
      case 'kitchen':
        newBgImage = '/kitchen_bg.png';
        break;
      default:
        newBgImage = '/home_bg.png';
    } 
    setBgImage(newBgImage);  // Update the background image
  };
  return (
    <div className={styles.content}>
      <div className={styles.backImg} style={{ backgroundImage: `url(${bgImage})` }}>
        <div className={styles.controlBox}>

        </div>
      </div>
      <div className={styles.controls}>
        <div className={styles.title}>Rooms</div>
        <div className={styles.rooms}>
          <div className={styles.roomButton} onClick={() => handleRoomClick('living room')}>living room</div>
          <div className={styles.roomButton} onClick={() => handleRoomClick('bedroom')}>bedroom</div>
          <div className={styles.roomButton} onClick={() => handleRoomClick('kitchen')}>kitchen</div>
        </div>
        <div className={styles.devices}>
          <div className={styles.devicesBox}>Air conditioner</div>
          <div className={styles.devicesBox}>Ceiling fan</div>
        </div>
        <div className={styles.usage}>
          usage
        </div>
        <div className={styles.devices}>
          <div className={styles.devicesBox}>Temperature</div>
          <div className={styles.devicesBox}>Humidity</div>
        </div>
      </div>
    </div>
  );
};

export default Homes;
