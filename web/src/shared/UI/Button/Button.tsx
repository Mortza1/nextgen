import { ButtonHTMLAttributes, FC, PropsWithChildren } from "react";
import classNames from "classnames";

import { montserrat } from "@app/shared/fonts";

import styles from "./styles.module.css";

type ButtonVariant = "contained" | "text" | "outlined" | "purple";
type ButtonColor = "primary" | "secondary";

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  color?: ButtonColor;
}

const Button: FC<PropsWithChildren<ButtonProps>> = ({
  children,
  variant,
  className,
  color,
  ...props
}) => {
  const _defaultVariant = variant || "contained";
  const _defaultColor = color || "primary";

  const buttonClassNames = classNames(
    montserrat.className,
    styles.buttonBase,
    styles[_defaultVariant],
    styles[_defaultColor],
    className
  );

  return (
    <button className={buttonClassNames} {...props}>
      {children}
    </button>
  );
};

export default Button;
