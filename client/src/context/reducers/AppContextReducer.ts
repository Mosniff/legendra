import {
  AppContextActionTypes,
  type AppContextState,
  type AppScreen,
} from "@/types/appContextTypes";

export type SetScreenAction = {
  type: AppContextActionTypes.SET_SCREEN;
  payload: AppScreen | null;
};

export type AppContextActions = SetScreenAction;

export const appContextReducer = (
  state: AppContextState,
  action: AppContextActions
): AppContextState => {
  switch (action.type) {
    case AppContextActionTypes.SET_SCREEN:
      return {
        ...state,
        currentScreen: action.payload,
      };
    default:
      console.error("Unknown action in appContextReducer:", action);
      throw new Error();
  }
};
