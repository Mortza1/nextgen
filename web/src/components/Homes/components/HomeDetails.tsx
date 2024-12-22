import React from "react";
import styles from "./HomeDetails.module.css";

interface HomeDetailsProps {
  home: any; // Receive the home object as a prop
}

const HomeDetails: React.FC<HomeDetailsProps> = ({ home }) => {
  return (
    <div className={styles.homeDetails}>
      <h2 className={styles.homeName}>{home.name}</h2>
      <p className={styles.homeAddress}>{home.address}</p>

      <div className={styles.dwellers}>
        <h3>Dwellers:</h3>
        {home.dwellers && home.dwellers.length > 0 ? (
          <ul>
            {home.dwellers.map((dweller: any, index: number) => (
              <li key={index}>{dweller.name}</li>
            ))}
          </ul>
        ) : (
          <p>No dwellers added</p>
        )}
      </div>

      <div className={styles.devices}>
        <h3>Devices:</h3>
        {home.devices && home.devices.length > 0 ? (
          <ul>
            {home.devices.map((device: any, index: number) => (
              <li key={index}>{device.name}</li>
            ))}
          </ul>
        ) : (
          <p>No devices added</p>
        )}
      </div>
    </div>
  );
};

export default HomeDetails;
