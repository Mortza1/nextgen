import classNames from "classnames";
import styles from "./styles.module.css";

export type SvgIconProps = {
  className?: string;
};

const SvgIconWrap: React.FC<React.PropsWithChildren<SvgIconProps>> = ({
  children,
  className,
}) => {
  return (
    <span className={classNames(styles.iconWrapContainer, className)}>
      {children}
    </span>
  );
};

export default SvgIconWrap;
