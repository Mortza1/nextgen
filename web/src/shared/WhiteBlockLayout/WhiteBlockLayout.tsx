import { FC, PropsWithChildren } from "react";
import classNames from "classnames";

import styles from "./styles.module.css";

interface WhiteBlockLayoutProps {
  className?: string;
}

const WhiteBlockLayout: FC<PropsWithChildren<WhiteBlockLayoutProps>> = ({
  children,
  className,
}) => {
  return (
    <div className={classNames(styles.container, className)}>{children}</div>
  );
};

export default WhiteBlockLayout;
