import { memo, useState } from "react";
import styles from "./styles.module.css";
import LeftNav from "./components/LeftNav";
import TopNav from "./components/TopNav";
import Stats from "./components/Stats"; // Create this component
import Homes from "../Homes/Homes";

const Dashboard: React.FC = () => {
  const [activeScreen, setActiveScreen] = useState<string>("DASHBOARD");

  const renderScreen = () => {
    switch (activeScreen) {
      case "DASHBOARD":
        return (
          <div className={styles.body}>
            <div className={styles.content}>
            <Stats totalUsage={"500W"} />
            <div className={styles.analytics}></div>
            </div>
            
          </div>
        );
      case "HOMES":
        return <div className={styles.body}><Homes /></div>;
      default:
        return <div className={styles.body}>Not Found</div>;
    }
  };

  return (
    <div className={styles.main}>
      <TopNav onSelect={(screen) => setActiveScreen(screen)} />
      <div className={styles.mainContent}>
        <LeftNav />
        {renderScreen()}
      </div>
    </div>
  );
};

export default memo(Dashboard);
