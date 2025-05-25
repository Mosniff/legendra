import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useQueryClient } from "@tanstack/react-query";

export const SignOut = () => {
  const { state: userContextState, dispatch, userService } = useAuthContext();
  const queryClient = useQueryClient();
  return (
    <button
      onClick={() => {
        userService.signOut(userContextState.authToken || "no token found");
        dispatch({
          type: AuthContextActionTypes.SET_AUTH_TOKEN,
          payload: null,
        });
        localStorage.removeItem("authToken");
        queryClient.invalidateQueries({ queryKey: ["user"] });
      }}
    >
      Logout
    </button>
  );
};
