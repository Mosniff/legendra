import { useAppContext } from "@/context/AppContext";
import { useAuthContext } from "@/context/AuthContext";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useQueryClient } from "@tanstack/react-query";

export const SignOut = () => {
  const {
    state: authContextState,
    dispatch: authContextDispatch,
    userService,
  } = useAuthContext();
  const { dispatch: appContextDispatch } = useAppContext();
  const queryClient = useQueryClient();
  return (
    <button
      onClick={() => {
        userService.signOut(authContextState.authToken || "no token found");
        authContextDispatch({
          type: AuthContextActionTypes.SET_AUTH_TOKEN,
          payload: null,
        });
        appContextDispatch({
          type: AppContextActionTypes.SET_SCREEN,
          payload: null,
        });
        localStorage.removeItem("authToken");
        queryClient.setQueryData(["user"], null);
      }}
    >
      Logout
    </button>
  );
};
