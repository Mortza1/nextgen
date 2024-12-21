import React, { useState, useEffect, useMemo } from "react";
import Head from "next/head";
import { useRouter } from "next/router";
import styles from "../styles.module.css";

const RoomPage = () => {
  // const router = useRouter();
  // const { roomId } = router.query as { roomId: string };
  // const rooms = useRoomsContext();
  // const user = useUserContext();

  // const currentRoom = useMemo(
  //   () => rooms.find((room) => room._id === roomId) || ({} as ChatRoom),
  //   [roomId, rooms]
  // );

  
  return (
    <>
      <Head>
        <title>{`nextgen`}</title>
        <meta name="description" content="nextgen App" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div className={styles.pageContainer}>
  
      </div>
    </>
  );
};

export default RoomPage;
