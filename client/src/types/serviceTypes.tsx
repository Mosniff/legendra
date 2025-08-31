import type { AxiosResponse } from "axios";
import type { Game, ScenarioTemplate } from "./gameTypes";
import type { SignInUser, User } from "./authContextTypes";

export type UserService = {
  // TODO: remove any
  signUp: (userObject: SignInUser) => any;
  signIn: (userObject: SignInUser) => any;
  signOut: (authToken: string) => any;
  getUser: (authToken: string) => Promise<User | null>;
  createGameForUser: (authToken: string, slot: number) => any;
  setActiveGameForUser: (authToken: string, id: string) => any;
  deleteGameForUser: (authToken: string, id: string) => any;
};

export type GameService = {
  getGame: (authToken: string, id: string) => Promise<Game | null>;
  getScenarioTemplates: (
    authToken: string
  ) => Promise<ScenarioTemplate[] | null>;
  setStoryForGame: (
    authToken: string,
    id: string,
    storyKey: string
  ) => Promise<AxiosResponse | null>;
};

export type CastleService = {
  createArmyFromGarrison: (
    authToken: string,
    gameId: string,
    garrisonId: string,
    selectedGeneralIds: string[]
  ) => Promise<AxiosResponse | null>;
};
