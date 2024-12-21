import { useRef, useEffect } from "react";
import { createPortal } from "react-dom";
import classNames from "classnames";

import CloseIcon from "@app/shared/SvgIcons/CloseIcon";
import IconButton from "../IconButton";
import styles from "./styles.module.css";

interface ModalProps {
  classNameContainer?: string;
  classNameBackDrop?: string;
  classNameBody?: string;
  classNameTitleContainer?: string;
  classNameTitle?: string;
  disabledBackdrop?: boolean;
  title: React.ReactNode;
  onClose?: () => void;
}

const rootElement = global?.document?.getElementById("modal-root") || null;

const Modal: React.FC<React.PropsWithChildren<ModalProps>> = ({
  children,
  classNameBackDrop,
  classNameBody,
  classNameContainer,
  classNameTitleContainer,
  classNameTitle,
  disabledBackdrop,
  title,
  onClose,
}) => {
  const rootRef = useRef<HTMLDivElement | null>(null);

  const classNamesContainer = classNames(
    styles.modalContainer,
    classNameContainer
  );
  const classNamesBackDrop = classNames(styles.backdrop, classNameBackDrop);
  const classNamesBody = classNames(styles.modalBodyContainer, classNameBody);
  const classNamesTitleContainer = classNames(
    styles.modalBodyTitleContainer,
    classNameTitleContainer
  );

  const classNamesTitle = classNames(styles.classNameTitle, classNameTitle);

  const handleClickCloseButton = (
    event: React.MouseEvent<HTMLButtonElement>
  ) => {
    event.stopPropagation();
    if (typeof onClose === "function") {
      onClose();
    }
  };

  const modalElement = (
    <div className={classNamesContainer}>
      {!disabledBackdrop && <div className={classNamesBackDrop}></div>}
      <div className={classNamesBody} autoFocus>
        {!!title && (
          <div className={classNamesTitleContainer}>
            <span className={classNamesTitle}>{title}</span>
            {onClose && (
              <IconButton
                className={styles.modalCloseButton}
                onClick={handleClickCloseButton}
              >
                <CloseIcon />
              </IconButton>
            )}
          </div>
        )}
        {children}
      </div>
    </div>
  );

  useEffect(() => {
    rootRef.current = rootElement as HTMLDivElement;
  }, []);

  return rootRef.current && createPortal(modalElement, rootElement!);
};

export default Modal;
