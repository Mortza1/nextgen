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
const baseURL = "http://localhost:8000/";

const clientApi = new ClientApi(
  axios.create({
    baseURL,
  }),
  getUserId()
);

// export const TEST_USER_ID = "993366"; "993367"; "993368"
export const TEST_USER_ID = "993378";
export default clientApi;
