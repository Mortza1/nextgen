import Head from "next/head";
import classNames from "classnames";
import styles from "./styles.module.css";
import Dashboard from "@app/components/Dashboard";

export default function RootPage() {
  return (
    <>
      <Head>
        <title>{`nextGen | loading...`}</title>
        <meta name="description" content="nextGen App" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div
        className={classNames(styles.pageContainer, styles.rootPageContainer)}
      >
        <div className={styles.pageContainer}>
            <Dashboard/>
        </div>
      </div>
    </>
  );
}
