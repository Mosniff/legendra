import {
  AuthContextActionTypes,
  type AuthContextState,
} from "@/types/authContextTypes";

type SetAuthTokenAction = {
  type: AuthContextActionTypes.SET_AUTH_TOKEN;
  payload: string | null;
};

export type AuthContextActions = SetAuthTokenAction;

export const authContextReducer = (
  state: AuthContextState,
  action: AuthContextActions
): AuthContextState => {
  switch (action.type) {
    case "SET_AUTH_TOKEN":
      return {
        ...state,
        authToken: action.payload,
      };
    default:
      console.error("Unknown action in authContextReducer:", action);
      throw new Error();
  }
};
