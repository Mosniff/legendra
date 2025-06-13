import type { AppContextActions } from "@/context/reducers/AppContextReducer";
import type { GameService } from "./gameTypes";

export type AppContextState = {
  currentScreen: AppScreen;
};

export type AppContextType = {
  state: AppContextState;
  dispatch: React.Dispatch<AppContextActions>;
  gameService: GameService;
};

export enum AppContextActionTypes {
  SET_SCREEN = "SET_SCREEN",
}

export type AppScreen = "Game Select" | "Game Menu" | null;
