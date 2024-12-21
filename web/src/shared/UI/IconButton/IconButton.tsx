import { ButtonHTMLAttributes, FC, PropsWithChildren } from "react";
import classNames from "classnames";

import styles from "./styles.module.css";

interface IconButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {}

const IconButton: FC<PropsWithChildren<IconButtonProps>> = ({
  children,
  className,
  ...props
}) => {
  const iconButtonClassNames = classNames(styles.iconButton, className);
  return (
    <button {...props} className={iconButtonClassNames}>
      {children}
    </button>
  );
};

export default IconButton;
