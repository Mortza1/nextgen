import React, { InputHTMLAttributes, forwardRef } from "react";
import classNames from "classnames";

import { montserrat } from "@app/shared/fonts";
import styles from "./styles.module.css";

type InputSize = "large" | "medium" | "small";

interface TextFieldProps extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  classNameInput?: string;
  startIcon?: React.ReactElement;  // Add startIcon prop
  endIcon?: React.ReactElement;
  inputSize?: InputSize;
}

const TextField = forwardRef<HTMLInputElement, TextFieldProps>(
  ({ className, classNameInput, startIcon, endIcon, inputSize, ...props }, ref) => {
    const _defaultInputSize = inputSize || "medium";

    const classNamesContainer = classNames(
      styles.inputContainer,
      styles[_defaultInputSize],
      className
    );

    const classNamesInput = classNames(
      montserrat.className,
      styles.input,
      classNameInput
    );

    return (
      <div className={classNamesContainer}>
        {!!startIcon ? <span className={styles.startIcon}>{startIcon}</span> : null} {/* Add startIcon rendering */}
        <input type="text" className={classNamesInput} {...props} ref={ref} />
        {!!endIcon ? <span className={styles.endIcon}>{endIcon}</span> : null}
      </div>
    );
  }
);

TextField.displayName = "TextField";

export default TextField;
