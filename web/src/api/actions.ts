import clientApi from "@app/api";
import { getUserId } from "@app/services/auth";

export interface RegisterParams {
  name: string
  email: string;
  password: string
}


export interface AuthParams {
  userId: string;
  profileId: string
}

// export const registerUser = async ({
//   email, password
// } : RegisterParams) => {
//   try {
//     const { data } = await clientApi.room.register({email, password});
//     if (data.statusCode === 200 || data.statusCode === 201) {
//       console.log(data.data)
//       return data.data;
//     }
//     throw Error(data.responseInfo.message);
//   } catch (error) {
//     //TODO:
//   }
// };

export const registerManager = async ({
  name, email, password
} : RegisterParams) => {
  try {
    const { data } = await clientApi.room.register_manager({name, email, password});
    if (data.statusCode === 200 || data.statusCode === 201) {
      console.log(data.data)
      return data.data;
    }
    throw Error(data.responseInfo.message);
  } catch (error) {
    console.log(error, "ssssssssssss");
    //TODO:
  }
};

export const getUser = async () => {
  try {
    const id = getUserId();
    
    const { data } = await clientApi.room.getUser({id});
    if (data.statusCode === 200 || data.statusCode === 201) {
      return data.data;
    }
    throw Error(data.responseInfo.message);
  } catch (error) {
    //TODO:
  }
};

export const loginUser = async ({
  userId, profileId
} : AuthParams) => {
  try {
    const { data } = await clientApi.room.login(userId, profileId);
    if (data.statusCode === 200 || data.statusCode === 201) {
      console.log(data.data)
      return data.data;
    }
    throw Error(data.responseInfo.message);
  } catch (error) {
    //TODO:
  }
};

