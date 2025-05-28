import { AppHeader } from "@/components/AppHeader";
import { ScreenContainer } from "@/components/ScreenContainer";
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
    <div className="flex w-full h-full items-center justify-center p-12">
      <div
        style={{
          width: "800px",
          maxWidth: "800px",
          height: "400px",
          maxHeight: "400px",
        }}
      >
        <AppHeader />
        <ScreenContainer />
      </div>
    </div>
  );
};
