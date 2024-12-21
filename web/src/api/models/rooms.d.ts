declare module "rooms-model" {

  export interface RegisterRequestData {
    name: string;
    email: string;
    password: string;
  }

  export interface AuthRequestData {
    userId: string;
    profileId: string;
  }

  export interface getUserData {
    id: string
  }

  export interface RegisterResponse {
    user_id: string;
  }

  
}