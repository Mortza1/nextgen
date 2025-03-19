import React from "react";
import styles from "../styles.module.css";
import Stats from "./Stats"; // Import your Stats component
import CircularProgress from "./progress";
import EnergyUsageChart from "./graph";

const DashboardScreen: React.FC = () => {
  const energyDataJan = [
    { x: new Date("2024-01-01"), y: 120 },
    { x: new Date("2024-01-02"), y: 140 },
    { x: new Date("2024-01-03"), y: 130 },
    { x: new Date("2024-01-04"), y: 150 },
    { x: new Date("2024-01-05"), y: 170 },
    { x: new Date("2024-01-06"), y: 180 },
    { x: new Date("2024-01-07"), y: 160 },
  ];

  const energyDataFeb = [
    { x: new Date("2024-01-01"), y: 110 },
    { x: new Date("2024-01-02"), y: 125 },
    { x: new Date("2024-01-03"), y: 135 },
    { x: new Date("2024-01-04"), y: 140 },
    { x: new Date("2024-01-05"), y: 150 },
    { x: new Date("2024-01-06"), y: 170 },
    { x: new Date("2024-01-07"), y: 165 },
  ];
  return (
    <div className={styles.content}>
      <div className={styles.top}></div>
      <div className={styles.bottom}>
        <div className={styles.totalDevices}>
          <div className={styles.title}>Devices currently running</div>
          <div className={styles.percentageRow}>
            <div className={styles.percentage}>100%</div>
            <div className={styles.percentageCol}>
            <CircularProgress percentage={75} /> 
            <div className={styles.percentage}>70%</div>
            </div>
            <div className={styles.percentage}>0%</div>
          </div>

        </div>
        <div className={styles.usageGraph}>
        <EnergyUsageChart
        month1="January"
        month2="February"
        dataMonth1={energyDataJan}
        dataMonth2={energyDataFeb}
      />
        </div>
      </div>
    </div>
  );
};

export default DashboardScreen;
