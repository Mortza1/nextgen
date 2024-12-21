import SvgIconWrap, { SvgIconProps } from "./SvgIconWrap";

const CloseIcon: React.FC<SvgIconProps> = (props) => {
  return (
    <SvgIconWrap {...props}>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        strokeWidth={1.5}
        stroke="currentColor"
        width="1em"
        height="1em"
        fontSize={"inherit"}
        focusable={false}
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M6 18 18 6M6 6l12 12"
        />
      </svg>
    </SvgIconWrap>
  );
};

export default CloseIcon;
