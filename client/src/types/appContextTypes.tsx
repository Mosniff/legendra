import type { AppContextActions } from "@/context/reducers/AppContextReducer";

export type AppContextState = {
  currentScreen?: AppScreen;
};

export type AppContextType = {
  state: AppContextState;
  dispatch: React.Dispatch<AppContextActions>;
};

export enum AppContextActionTypes {
  SET_SCREEN = "SET_SCREEN",
}

export type AppScreen = "Game Select";
