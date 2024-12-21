import { ChatRooms} from "rooms-model";

export const sortRooms = (rooms: ChatRooms): ChatRooms => {
  if (!rooms || !rooms.length) return rooms;
  return [...rooms].sort((a, b) => {
    if (a.date_modified === b.date_modified) {
      return 0;
    }

    return new Date(a.date_modified).getTime() >
      new Date(b.date_modified).getTime()
      ? -1
      : 1;
  });
};

const leftOrRight = () => {
  return Math.round(Math.random());
};

export const getRandomId = (isTwoVar?: boolean) => {
  return globalThis?.crypto && !isTwoVar
    ? globalThis.crypto?.randomUUID()
    : (Math.random() * 10 * new Date().getTime()).toString(16).replace(".", "");
};

// export const getIdWithOnlySymbol = () => {
//   return (getRandomId(true) + getRandomId(true)).replaceAll(/[^\p{L}]/gu, "");
// };
