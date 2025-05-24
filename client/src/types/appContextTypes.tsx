import type { AppContextActions } from "@/context/reducers/AppContextReducer";

export type AppContextState = {
  currentScreen?: AppScreen;
};

export type AppContextType = {
  state: AppContextState;
  dispatch: React.Dispatch<AppContextActions>;
  gameService: GameService;
};

export enum AppContextActionTypes {
  SET_SCREEN = "SET_SCREEN",
}

export type AppScreen = "Game Select" | "Game Menu";

export type GameService = {
  getGame: (authToken: string, id: string) => Promise<Game | null>;
};

export type Game = {
  id: string;
  slot: number;
  active: boolean;
  world: GameWorld;
};

export type GameWorld = {};
