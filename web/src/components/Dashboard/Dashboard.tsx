import { memo, useState } from "react";
import styles from "./styles.module.css";
import LeftNav from "./components/LeftNav";
import Homes from "../Homes/Homes";
import DashboardScreen from "./components/DashboardScreen";
import Devices from "../Devices";
import Dwellers from "../Dwellers";
import Notifications from "../Notifications";
import Settings from "../Settings";

const Dashboard: React.FC = () => {
  const [activeScreen, setActiveScreen] = useState<string>("DASHBOARD");

  const renderScreen = () => {
    switch (activeScreen) {
      case "DASHBOARD":
        return (
          <DashboardScreen/>
        );
      case "HOMES":
        return (<Homes />);
      case "DWELLERS":
        return (<Dwellers/>);
      case "DEVICES":
        return (<Devices />);
        case "NOTIFICATIONS":
        return (<Notifications />);
        case "SETTINGS":
          return (<Settings />);
      default:
        return <div className={styles.body}>Not Found</div>;
    }
  };

  return (
    <div className={styles.main}>
      <LeftNav activeScreen={activeScreen} setActiveScreen={setActiveScreen} />
      <div className={styles.body}>{renderScreen()}</div>
    </div>
  );
};

export default memo(Dashboard);
