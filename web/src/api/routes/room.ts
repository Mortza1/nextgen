import type { AxiosInstance, AxiosProgressEvent, AxiosPromise } from "axios";
import Base from "./base";
import {
  AddHomeRequestData,
  getHomeData,
  getHomeUsersData,
  getUserData,
  RegisterRequestData,
  RegisterResponse,
  sendInviteData,
} from "rooms-model";

export class RoomApi extends Base {

  getUser(
    data: getUserData
  ) {
    return this.httpClient({
      url: `${this.url}/user`,
      method: "POST",
      data,
    });
  }

  sendInvite(
    data: sendInviteData
  ) {
    return this.httpClient({
      url: `${this.url}/management/invite-dweller`,
      method: "POST",
      data,
    });
  }

  getHomeUsers(
    data: getHomeUsersData
  ) {
    return this.httpClient({
      url: `${this.url}/management/home-dwellers`,
      method: "POST",
      data,
    });
  }

  getHomes(
    data: getHomeData
  ) {
    return this.httpClient({
      url: `${this.url}/management/homes`,
      method: "POST",
      data,
    });
  }

  register(
    data: RegisterRequestData
  ): AxiosPromise<CommonResponseApi<RegisterResponse>> {
    return this.httpClient({
      url: `${this.url}/register`,
      method: "POST",
      data,
    });
  }

  register_manager(
    data: RegisterRequestData
  ): AxiosPromise<CommonResponseApi<RegisterResponse>> {
    return this.httpClient({
      url: `${this.url}/auth/register-manager`,
      method: "POST",
      data,
    });
  }

  add_home(
    data: AddHomeRequestData
  ): AxiosPromise<CommonResponseApi<RegisterResponse>> {
    return this.httpClient({
      url: `${this.url}/management/add-home`,
      method: "POST",
      data,
    });
  }

  login(
    userid: string, profileid: string
  ): AxiosPromise<CommonResponseApi<RegisterResponse>> {
    return this.httpClient({
      url: `${this.url}/login/${userid}/${profileid}`,
      method: "POST",
    });
  }

}

export default function roomApi(httpClient: AxiosInstance) {
  return new RoomApi({
    url: "",
    httpClient,
  });
}
