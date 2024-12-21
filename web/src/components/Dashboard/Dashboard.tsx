import { memo, useEffect, useState } from "react";
import styles from "./styles.module.css";
import LeftNav from "./components/LeftNav";
import TopNav from "./components/TopNav";
import Stats from "./components/Stats";


const Dashboard: React.FC = () => {
  const [activeIndex, setActiveIndex] = useState<number | null>(null);

  const handleClick = (index: number) => {
    setActiveIndex(index);
  };
  return (
    <div className={styles.main}>
      <TopNav />
      <div className={styles.mainContent}>
        <LeftNav/>
        <div className={styles.body}>
          <Stats totalUsage={"500W"} />
          <div className={styles.analytics}></div>
        </div>
      </div>
    </div>
  );
};

export default memo(Dashboard);
