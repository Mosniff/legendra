import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useEffect } from "react";
import { SignIn } from "@/components/SignIn";
import { SignUp } from "@/components/SignUp";
import { SignOut } from "@/components/SignOut";
import { useQuery } from "@tanstack/react-query";
import { GameSelectScreen } from "./screens/GameSelectScreen";

export const GameContainer = () => {
  const { state: authContextState, dispatch, userService } = useAuthContext();
  useEffect(() => {
    const storedToken = localStorage.getItem("authToken");
    if (storedToken && authContextState.authToken !== storedToken) {
      dispatch({
        type: AuthContextActionTypes.SET_AUTH_TOKEN,
        payload: storedToken,
      });
    }
  }, []);

  const { data: user, isLoading } = useQuery({
    queryKey: ["user"],
    queryFn: () => userService.getUser(authContextState.authToken!),
    enabled: !!authContextState.authToken,
  });

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
          <GameSelectScreen />
        </>
      )}
    </div>
  );
};
