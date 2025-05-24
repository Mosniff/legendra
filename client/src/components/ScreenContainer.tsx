import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useEffect } from "react";
import { SignIn } from "@/components/SignIn";
import { SignUp } from "@/components/SignUp";
import { SignOut } from "@/components/SignOut";
import { GameSelectScreen } from "./screens/GameSelectScreen";
import { useAppContext } from "@/context/AppContext";
import { GameContainer } from "@/components/GameContainer";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";

export const ScreenContainer = () => {
  const { state: authContextState, dispatch } = useAuthContext();
  useEffect(() => {
    const storedToken = localStorage.getItem("authToken");
    if (storedToken && authContextState.authToken !== storedToken) {
      dispatch({
        type: AuthContextActionTypes.SET_AUTH_TOKEN,
        payload: storedToken,
      });
    }
  }, []);

  const { data: user, isLoading } = useUserQuery();
  const { state: appContextState } = useAppContext();

  return (
    <div>
      {isLoading && <div>Loading...</div>}
      {!isLoading && (
        <>
          {user && authContextState.authToken && (
            <div>
              <SignOut />
            </div>
          )}
          {(!user || !authContextState.authToken) && (
            <div>
              <SignIn />
              <SignUp />
            </div>
          )}
          {user && (
            <>
              <div>Signed in user: {user?.email}</div>
            </>
          )}
          {appContextState.currentScreen === "Game Select" && (
            <GameSelectScreen />
          )}
          {appContextState.currentScreen !== "Game Select" && <GameContainer />}
        </>
      )}
    </div>
  );
};
