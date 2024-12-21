import { jwtDecode } from "jwt-decode";

interface User {
  userId: string;
  ProfileID: string;
}

export const getUserFromToken = (token: string) => {
  try {
    return { userId: token };
    // return jwtDecode<User>(token); // Correctly call jwtDecode as a function
  } catch (error) {
    console.error('Failed to decode token:', error);
    return null;
  }
};
