import type { AppContextActions } from "@/context/reducers/AppContextReducer";
import type { GameService, CastleService } from "@/types/serviceTypes";

export type AppContextState = {
  currentScreen: AppScreen;
};

export type AppContextType = {
  state: AppContextState;
  dispatch: React.Dispatch<AppContextActions>;
  gameService: GameService;
  castleService: CastleService;
};

export enum AppContextActionTypes {
  SET_SCREEN = "SET_SCREEN",
}

export type AppScreen = "Game Select" | "Game Menu" | null;
