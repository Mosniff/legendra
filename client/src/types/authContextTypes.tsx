import { type AuthContextActions } from "@/context/reducers/AuthContextReducer";
import type { UserService } from "@/types/serviceTypes";

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

// TODO: password encryption
export type SignInUser = { user: { email: string; password: string } };
export type User = {
  email: string;
  gamesMetadata: GameMetadata[];
  activeGameId: string | null;
};

export type GameMetadata = {
  id: string;
  slot: SlotNumber;
  active: boolean;
};

export type SlotNumber = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9;
