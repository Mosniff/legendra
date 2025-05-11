import { createContext, useContext, useReducer, type ReactNode } from "react";
import {
  type UserContextType,
  type UserContextState,
  type UserService,
} from "@/types/userContextTypes";
import { userContextReducer } from "@/reducers/UserContextReducer";

const initialState: UserContextState = {};

export const UserContext = createContext<UserContextType | null>(null);

export const UserContextProvider = ({
  children,
  userService,
}: {
  children: ReactNode;
  userService: UserService;
}) => {
  const [state, dispatch] = useReducer(userContextReducer, initialState);

  return (
    <UserContext.Provider value={{ state, dispatch, userService }}>
      {children}
    </UserContext.Provider>
  );
};

export const useUserContext = () => {
  const context = useContext(UserContext);

  if (!context) {
    throw new Error(
      "The User Context must be used within an UserContextProvider"
    );
  }

  return context;
};
