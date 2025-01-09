import axios from "axios";
import type { AxiosInstance } from "axios";

import roomApi, { RoomApi } from "./routes/room";
import { getUserId } from "@app/services/auth";
 
class ClientApi {
  // Declare Api routes
  public readonly room: RoomApi;

  constructor(
    private readonly httpClient: AxiosInstance,
    public readonly userId: string
  ) {
    /**
     * initialize API routes
     */
    this.room = roomApi(this.httpClient);
  }
}
//
const baseURL = "https://d98f-2-51-19-23.ngrok-free.app/";

const clientApi = new ClientApi(
  axios.create({
    baseURL,
  }),
  getUserId()
);

// export const TEST_USER_ID = "993366"; "993367"; "993368"
export const TEST_USER_ID = "993378";
export default clientApi;
