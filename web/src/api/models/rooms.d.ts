declare module "rooms-model" {

  export interface RegisterRequestData {
    name: string;
    email: string;
    password: string;
  }

  export interface LoginRequestData {
    email: string;
    password: string;
  }

  export interface AddHomeRequestData {
    home_name: string;
    address: string;
    manager_id: string;
    devices: string[] = [];
    dwellers: string[] = [];
  }

  export interface AuthRequestData {
    userId: string;
    profileId: string;
  }

  export interface getUserData {
    id: string
  }

  export interface sendInviteData {
    email: string,
    house_id: string,
    manager_id: string
  }

  export interface getHomeData {
    manager_id: string
  }

  export interface getDevicesData {
    user_id: string,
    hub_id: string
  }

  export interface getHomeUsersData {
    user_ids: string[];
  }

  export interface RegisterResponse {
    user_id: string;
  }
  export interface HomeResponse {
    home_id: string;
  }

  
}