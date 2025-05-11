import {
  UserContextActionTypes,
  type User,
  type UserContextState,
} from "@/types/userContextTypes";

type SetUserAction = {
  type: UserContextActionTypes.SET_USER;
  payload: User | null;
};

type SetAuthTokenAction = {
  type: UserContextActionTypes.SET_AUTH_TOKEN;
  payload: string | null;
};

export type UserContextActions = SetUserAction | SetAuthTokenAction;

export const userContextReducer = (
  state: UserContextState,
  action: UserContextActions
): UserContextState => {
  switch (action.type) {
    case "SET_USER":
      return {
        ...state,
        user: action.payload,
      };
    case "SET_AUTH_TOKEN":
      return {
        ...state,
        authToken: action.payload,
      };
    default:
      throw new Error();
  }
};
