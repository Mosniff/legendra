import { type AuthContextActions } from "@/context/reducers/AuthContextReducer";

export type AuthContextType = {
  state: AuthContextState;
  dispatch: React.Dispatch<AuthContextActions>;
  userService: UserService;
};

export type AuthContextState = {
  authToken?: string | null;
};

export enum AuthContextActionTypes {
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
export type User = { email: string; gamesMetadata: GameMetadata[] };

export type GameMetadata = {
  id: string;
  slot: SlotNumber;
};

export type SlotNumber = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9;
