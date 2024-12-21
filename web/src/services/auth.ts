export const STORAGE_USER_ID_KEY = "userId";

export const getUserId = (): string => {
  if (typeof window !== "undefined") {  // Check if the code is running on the client side
    const localId = localStorage.getItem(STORAGE_USER_ID_KEY);
    if (localId) {
      return localId;
    }
  }
  return "";
};