import { useMutation } from "@tanstack/react-query";
import { useAuthContext } from "@/context/AuthContext";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import { useAppContext } from "@/context/AppContext";
import { AppContextActionTypes } from "@/types/appContextTypes";

export const useCreateGameMutation = () => {
  const { state: authContextState, userService } = useAuthContext();
  const { refetch: refetchUser } = useUserQuery();

  return useMutation({
    mutationFn: (slot: number) =>
      userService.createGameForUser(authContextState.authToken!, slot),
    onSuccess: () => {
      refetchUser();
    },
  });
};

export const useDeleteGameMutation = () => {
  const { state: authContextState, userService } = useAuthContext();
  const { refetch: refetchUser } = useUserQuery();

  return useMutation({
    mutationFn: (id: string) =>
      userService.deleteGameForUser(authContextState.authToken!, id),
    onSuccess: () => {
      refetchUser();
    },
  });
};

export const useSetActiveGameMutation = () => {
  const { state: authContextState, userService } = useAuthContext();
  const { refetch: refetchUser } = useUserQuery();
  const { dispatch: appContextDispatch } = useAppContext();

  return useMutation({
    mutationFn: (id: string) =>
      userService.setActiveGameForUser(authContextState.authToken!, id),
    onSuccess: () => {
      refetchUser().then(() => {
        appContextDispatch({
          type: AppContextActionTypes.SET_SCREEN,
          payload: "Game Menu",
        });
      });
    },
  });
};
