import type { AppContextState, AppContextType } from "@/types/appContextTypes";
import { createContext, useContext, useReducer, type ReactNode } from "react";
import { appContextReducer } from "./reducers/AppContextReducer";

const initialState: AppContextState = {
  currentScreen: "Game Select",
};

export const AppContext = createContext<AppContextType | null>(null);

export const AppContextProvider = ({ children }: { children: ReactNode }) => {
  const [state, dispatch] = useReducer(appContextReducer, initialState);

  return (
    <AppContext.Provider value={{ state, dispatch }}>
      {children}
    </AppContext.Provider>
  );
};

export const useAppContext = () => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error(
      "The App Context must be used within an AppContextProvider"
    );
  }
  return context;
};
