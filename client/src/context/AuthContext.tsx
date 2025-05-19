import { createContext, useContext, useReducer, type ReactNode } from "react";
import {
  type AuthContextType,
  type AuthContextState,
  type UserService,
} from "@/types/authContextTypes";
import { authContextReducer } from "@/context/reducers/AuthContextReducer";

const initialState: AuthContextState = {};

export const AuthContext = createContext<AuthContextType | null>(null);

export const AuthContextProvider = ({
  children,
  userService,
}: {
  children: ReactNode;
  userService: UserService;
}) => {
  const [state, dispatch] = useReducer(authContextReducer, initialState);

  return (
    <AuthContext.Provider value={{ state, dispatch, userService }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuthContext = () => {
  const context = useContext(AuthContext);

  if (!context) {
    throw new Error(
      "The Auth Context must be used within an AuthContextProvider"
    );
  }

  return context;
};
