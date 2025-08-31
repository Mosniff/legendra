import type { AppContextState, AppContextType } from "@/types/appContextTypes";
import type { CastleService, GameService } from "@/types/serviceTypes";
import { createContext, useContext, useReducer, type ReactNode } from "react";
import { appContextReducer } from "./reducers/AppContextReducer";

const initialState: AppContextState = {
  currentScreen: null,
};

export const AppContext = createContext<AppContextType | null>(null);

export const AppContextProvider = ({
  children,
  gameService,
  castleService,
}: {
  children: ReactNode;
  gameService: GameService;
  castleService: CastleService;
}) => {
  const [state, dispatch] = useReducer(appContextReducer, initialState);

  return (
    <AppContext.Provider
      value={{ state, dispatch, gameService, castleService }}
    >
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
