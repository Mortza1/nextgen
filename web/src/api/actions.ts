import clientApi from "@app/api";
import { getUserId } from "@app/services/auth";

export interface RegisterParams {
  name: string
  email: string;
  password: string
}
export interface GetHomeParams {
  manager_id: string
}
export interface SendInviteParams {
  manager_id: string,
  house_id: string,
  email: string
}
export interface AddHomeParams {
  home_name: string
  address: string
  manager_id: string
}


export interface AuthParams {
  userId: string;
  profileId: string
}
export interface getHomeUsersParams {
  user_ids: string[];
}


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

export const getHomes = async ({
  manager_id
} : GetHomeParams) => {
  try {
    const { data } = await clientApi.room.getHomes({manager_id});
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

export const sendInvite = async ({
  manager_id, house_id, email
} : SendInviteParams) => {
  try {
    const { data } = await clientApi.room.sendInvite({manager_id, house_id, email});
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
export const addHome = async ({
  home_name, address, manager_id
} : AddHomeParams) => {
  try {
    const { data } = await clientApi.room.add_home({
      home_name, address, manager_id,
      devices: [],
      dwellers: []
    });
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

export const getHomeUsers = async ({
  user_ids
} : getHomeUsersParams) => {
  try {
    const { data } = await clientApi.room.getHomeUsers({user_ids});
    if (data.statusCode === 200 || data.statusCode === 201) {
      console.log(data.data)
      return data.data;
    }
    throw Error(data.responseInfo.message);
  } catch (error) {
    //TODO:
  }
};

