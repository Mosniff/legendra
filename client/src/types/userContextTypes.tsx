import { type UserContextActions } from "@/reducers/UserContextReducer";
import { type Game } from "@/types/gameContextTypes";

export type UserContextType = {
  state: UserContextState;
  dispatch: React.Dispatch<UserContextActions>;
  userService: UserService;
};

export type UserContextState = {
  user?: User | null;
  authToken?: string | null;
};

export enum UserContextActionTypes {
  SET_USER = "SET_USER",
  SET_AUTH_TOKEN = "SET_AUTH_TOKEN",
}

export type UserService = {
  // TODO: remove any
  signUp: (userObject: SignInUser) => any;
  signIn: (userObject: SignInUser) => any;
  signOut: (authToken: string) => any;
  getUser: (authToken: string) => Promise<User | null>;
  createGame: (authToken: string, slot: number) => any;
};

// TODO: password encryption
export type SignInUser = { user: { email: string; password: string } };
export type User = { email: string; games: Game[] };
