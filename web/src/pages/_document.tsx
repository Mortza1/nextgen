import { Html, Head, Main, NextScript } from "next/document";
import { montserrat } from "@app/shared/fonts";

export default function Document() {
  return (
    <Html lang="en" className={montserrat.className}>
      <Head />
      <body>
        <Main />
        <NextScript />
        <div id="modal-root"></div>
      </body>
    </Html>
  );
}
