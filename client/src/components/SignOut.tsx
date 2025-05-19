import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";

export const SignOut = () => {
  const { state: userContextState, dispatch, userService } = useAuthContext();
  return (
    <button
      onClick={() => {
        userService.signOut(userContextState.authToken || "no token found");
        dispatch({
          type: AuthContextActionTypes.SET_AUTH_TOKEN,
          payload: null,
        });
        localStorage.removeItem("authToken");
      }}
    >
      Logout
    </button>
  );
};
