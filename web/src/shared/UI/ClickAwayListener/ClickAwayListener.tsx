import { useEffect, useRef, useCallback, Children, cloneElement } from "react";
import type { PropsWithChildren, ReactElement } from "react";

interface ClickAwayListenerProps extends PropsWithChildren {
  onClickAway: (v?: any) => void;
  children: ReactElement;
}

const ClickAwayListener: React.FC<ClickAwayListenerProps> = ({
  children,
  onClickAway,
}) => {
  const childrenRef = useRef<HTMLElement>(null);

  const handleOnClickAway = useCallback(
    (event: MouseEvent) => {
      const parent = childrenRef.current;

      if (parent) {
        const target = event.target as HTMLElement;
        if (parent === target || parent.contains(target)) return;
        onClickAway();
      }
    },
    [onClickAway]
  );

  useEffect(() => {
    window.document.addEventListener("click", handleOnClickAway);
    return () => {
      window.document.removeEventListener("click", handleOnClickAway);
    };
  }, [handleOnClickAway]);

  return (
    <span ref={childrenRef} style={{ display: "contents" }}>
      {/* {Children.map(children, (child) => {
        return cloneElement(child, {
          ref: childrenRef,
        });
      })} */}
      {children}
    </span>
  );
};

export default ClickAwayListener;
