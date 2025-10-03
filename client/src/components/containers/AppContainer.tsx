import { AppHeader } from "@/components/AppHeader";
import { ScreenContainer } from "@/components/containers/ScreenContainer";
import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useEffect } from "react";
import { useAppContext } from "@/context/AppContext";
import { GameSelectScreen } from "@/components/screens/GameSelectScreen";
import { GameMenuScreen } from "../screens/GameMenuScreen";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import { LoginScreen } from "../screens/LoginScreen";

export const AppContainer = () => {
  const { state: authContextState, dispatch } = useAuthContext();
  const { data: user, isLoading: isLoadingUser } = useUserQuery();
  const { state: appContextState } = useAppContext();

  useEffect(() => {
    const storedToken = localStorage.getItem("authToken");
    if (storedToken && authContextState.authToken !== storedToken) {
      dispatch({
        type: AuthContextActionTypes.SET_AUTH_TOKEN,
        payload: storedToken,
      });
    }
  }, []);

  let screen;
  switch (appContextState.currentScreen) {
    case "Game Select":
      screen = <GameSelectScreen />;
      break;
    case "Game Menu":
      screen = <GameMenuScreen />;
      break;
    default:
      screen = <GameSelectScreen />;
      break;
  }
  if (!user) {
    screen = <LoginScreen />;
  }

  return (
    <div className="h-screen w-full flex flex-col items-center">
      <AppHeader />
      {!isLoadingUser && <ScreenContainer>{screen}</ScreenContainer>}
    </div>
  );
};
