import React from 'react';
import styles from '../styles.module.css'; // Create a separate CSS file for this component

interface StatsProps {
  totalUsage: string; // Example of props to pass dynamic data
}

const Stats: React.FC<StatsProps> = ({ totalUsage }) => {
  return (
    <div className={styles.stats}>
      <div className={styles.left}>
        <div>
          <div className={styles.small}>Total usage</div>
        <div className={styles.large}>{totalUsage}</div>

        </div>
        <div className={styles.button}>View full stats</div>
      </div>
      <div>
        <img src='remote.png' alt="Stats" height={225} />
      </div>
    </div>
  );
};

export default Stats;
