import { AppHeader } from "@/components/AppHeader";
import { ScreenContainer } from "@/components/containers/ScreenContainer";
import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useEffect } from "react";

export const AppContainer = () => {
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

  return (
    <div className="h-screen w-full flex flex-col items-center">
      <AppHeader />
      <ScreenContainer />
    </div>
  );
};
