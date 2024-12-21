import { memo, useEffect, useState } from "react";
import styles from "./styles.module.css";
import { DotLottieReact } from '@lottiefiles/dotlottie-react';

const Homes: React.FC = () => {
    return (
        <div className={styles.main}>
            <div className={styles.add_home_row}>
            <div className={styles.heading}>Homes</div>
            <div className={styles.button}>Add Home</div>
            </div>

            <div className={styles.homes}>
            <DotLottieReact
                src="https://lottie.host/a3472677-7d54-48eb-95c0-730b7a7be56b/FyUW2IUG1h.lottie"
                loop
                autoplay
                style={{ width: '70%', height: '70%' }}
                />
            <div className={styles.text}>Add a home</div>
            </div>
        
      </div>
    );
  };
  
export default memo(Homes);
