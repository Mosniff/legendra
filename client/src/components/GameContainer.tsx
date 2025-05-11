import { useUserContext } from "@/context/UserContext";
import { UserContextActionTypes } from "@/types/userContextTypes";
import { useEffect } from "react";
import { SignIn } from "@/components/SignIn";
import { SignUp } from "@/components/SignUp";
import { SignOut } from "@/components/SignOut";

export const GameContainer = () => {
  // User Context
  const { state: userContextState, dispatch, userService } = useUserContext();
  useEffect(() => {
    const storedToken = localStorage.getItem("authToken");
    if (storedToken && userContextState.authToken !== storedToken) {
      dispatch({
        type: UserContextActionTypes.SET_AUTH_TOKEN,
        payload: storedToken,
      });

      const fetchUser = async () => {
        const user = await userService.getUser(storedToken);
        dispatch({
          type: UserContextActionTypes.SET_USER,
          payload: user,
        });
      };
      fetchUser();
    }
    console.log(userContextState);
  }, []);
  // /User Context

  return (
    <div>
      {userContextState.user && userContextState.authToken && (
        <div>
          <SignOut />
        </div>
      )}
      {(!userContextState.user || !userContextState.authToken) && (
        <div>
          <SignIn />
          <SignUp />
        </div>
      )}
    </div>
  );
};
