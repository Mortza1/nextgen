import SvgIconWrap, { SvgIconProps } from "./SvgIconWrap";

const NewIcon: React.FC<SvgIconProps> = (props) => {
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
          d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
        />
      </svg>
    </SvgIconWrap>
  );
};

export default NewIcon;
