import { memo, useState, useEffect } from "react";
import styles from "./styles.module.css";
import LeftNav from "./components/LeftNav";
import Homes from "../Homes/Homes";
import DashboardScreen from "./components/DashboardScreen";
import Devices from "../Devices";
import Dwellers from "../Dwellers";
import Notifications from "../Notifications";
import Settings from "../Settings";
import MonitoringScreen from "./components/MonitoringScreen";
import { getDevices, getHomes, getHomeUsers } from "@app/api/actions";

const Dashboard: React.FC = () => {
  const [activeScreen, setActiveScreen] = useState<string>("DASHBOARD");
  const [dwellers, setDwellers] = useState<any[]>([]); 
  const [managerId, setManagerId] = useState<string>(''); 
  const [houseId, setHouseId] = useState<string>(''); 
  const [devices, setDevices] = useState<any[]>([]);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const manager_id = localStorage.getItem("authToken"); // Get manager ID from localStorage
        if (!manager_id) {
          console.error("No manager ID found in localStorage");
          return;
        }

        setManagerId(manager_id); // Store the manager ID in state

        // Fetch homes data
        const homes = await getHomes({ manager_id: manager_id ?? '' });
        console.log("Homes response:", homes);
        setHouseId(homes['homes'][0]['_id']); // Store the house ID in state
        const hub_id = homes['homes'][0]['hub_id']; 
        // Extract user IDs from homes
        const users = homes['homes'][0]['dwellers'] || []; // Ensure `homes` is an array
        console.log("Users:", users);

        const user_ids = users.map((home: any) => home.user_id);
        console.log("User IDs:", user_ids); // Log the user IDs

        // Ensure `getHomeUsers` is called with the correct data
        if (user_ids.length > 0) {
          const users = await getHomeUsers({ 'user_ids': user_ids });
          console.log("Fetched users:", users);
          setDwellers(users['users']); 
        } else {
          console.warn("No user IDs found");
        }


        const devicesResponse = await getDevices({ user_id: managerId, hub_id: hub_id });
        console.log("Fetched devices:", devicesResponse);
        setDevices(devicesResponse.devices || []);
      } catch (error) {
        console.error("Error fetching homes:", error);
      }
    };

    fetchData(); // Call the async function
  }, []);

  const renderScreen = () => {
    switch (activeScreen) {
      case "DASHBOARD":
        return <DashboardScreen />;
      case "HOMES":
        return <Homes />;
      case "DWELLERS":
        return <Dwellers dwellers={dwellers} manager_id={managerId} house_id={houseId} />; // Pass managerId as a prop
      case "DEVICES":
        return <Devices devices={devices} />;
      case "NOTIFICATIONS":
        return <Notifications />;
      case "SETTINGS":
        return <Settings />;
      case "MONITORING":
        return <MonitoringScreen />;
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