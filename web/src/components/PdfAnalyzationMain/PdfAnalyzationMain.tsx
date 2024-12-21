import { memo, useEffect, useState } from "react";
import { HTML5Backend } from "react-dnd-html5-backend";
import { DndProvider } from "react-dnd";
import dynamic from "next/dynamic";
import styles from "./styles.module.css";
import { ChatRoom } from "rooms-model";
import { IoMenu } from "react-icons/io5";
import AsideMenu from "./components/AsideMenu";
import ChatScreen from "./components/ChatScreen";
import UserProfileDialog from "./components/UserProfileDialog";
import ChatMenu from "./components/ChatMenu";
import TemplateDialog from "./components/TemplateDialog";
// import BuyChannelContainer from "../Payment/BuyChannelContainer";

const UploadSection = dynamic(() => import("./components/UploadSection"), {
  ssr: false,
});

interface Props {
  room: ChatRoom;
  user: any;
}

const PdfAnalyzationMain: React.FC<Props> = ({ room, user }) => {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isDialogOpenTemplate, setIsDialogOpenTemplate] = useState(false);
  const [isSideMenuOpen, setIsSideMenuOpen] = useState(true);
  const [isChatOpen, setIsChatOpen] = useState(false); // Initially set to false

  const openDialog = () => {
    setIsDialogOpen(true);
  };

  const closeDialog = () => {
    setIsDialogOpen(false);
  };

  const openDialogTemplate = () => {
    setIsDialogOpenTemplate(true);
  };

  const closeDialogTemplate = () => {
    setIsDialogOpenTemplate(false);
  };
  const hasDocs = !!room?.docData?.data?.length || room?.docData?.data == '';
  const toggleSideMenu = () => {
    setIsSideMenuOpen(!isSideMenuOpen);
  };

  const toggleChat = () => {
    setIsChatOpen(!isChatOpen); // Toggle the chat menu
  };

  return (
    <DndProvider backend={HTML5Backend}>
      <div className={styles.main}>
        <AsideMenu
          isMenuVisible={isSideMenuOpen}
          toggleMenu={toggleSideMenu}
          openUserProfileDialog={openDialog}
          onClickTemplate={openDialogTemplate}
        />
        <div className={isSideMenuOpen ? styles.contentWithMenu : styles.fullContent}>
          {!isSideMenuOpen ? (
            <div className={styles.navButton} onClick={toggleSideMenu}>
              <IoMenu color="white" size={30} />
            </div>
          ) : (
            ""
          )}
          {hasDocs ? (
            <ChatScreen
              docData={room?.docData}
              nodes={room?.nodes}
              nodesForProps={room?.docData?.top_four_nodes}
              states={room?.states}
              roomUUID={room?.room_uuid}
              user={user}
              mapProgress={room?.mapProgress}
              widgets={room?.widgets}
              toggleChat={toggleChat}
              template={room?.template}
            />
          ) : (
            <UploadSection
              roomUUID={room?.room_uuid}
              hasDocData={hasDocs}
              nodes={room?.nodes || []}
                user={user}
                template={room?.template}
            />
          )}
        </div>
        <ChatMenu
          isMenuVisible={isChatOpen}
          toggleMenu={toggleChat}
          openUserProfileDialog={openDialog}
          roomUUID={room?.room_uuid}
          user={user}
        />
      </div>
      <UserProfileDialog isOpen={isDialogOpen} onClose={closeDialog} user={user} />
      <TemplateDialog isOpen={isDialogOpenTemplate} onClose={closeDialogTemplate} />
      {/* <BuyChannelContainer /> */}
    </DndProvider>
  );
};

export default memo(PdfAnalyzationMain);
