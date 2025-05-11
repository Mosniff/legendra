import { useUserContext } from "@/context/UserContext";
import { UserContextActionTypes } from "@/types/userContextTypes";

export const SignOut = () => {
  const { state: userContextState, dispatch, userService } = useUserContext();
  return (
    <button
      onClick={() => {
        userService.signOut(userContextState.authToken || "no token found");
        dispatch({
          type: UserContextActionTypes.SET_USER,
          payload: null,
        });
        dispatch({
          type: UserContextActionTypes.SET_AUTH_TOKEN,
          payload: null,
        });
        localStorage.removeItem("authToken");
      }}
    >
      Logout
    </button>
  );
};
