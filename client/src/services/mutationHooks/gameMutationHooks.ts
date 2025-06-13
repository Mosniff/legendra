import { useMutation } from "@tanstack/react-query";
import { useAuthContext } from "@/context/AuthContext";
import { useAppContext } from "@/context/AppContext";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";

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

export const useSetStoryForGameMutation = () => {
  const { state: authContextState } = useAuthContext();
  const { gameService } = useAppContext();
  const { refetch: refetchGame } = useGameQuery();

  return useMutation({
    mutationFn: ({ id, storyKey }: { id: string; storyKey: string }) =>
      gameService.setStoryForGame(authContextState.authToken!, id, storyKey),
    onSuccess: () => {
      refetchGame();
    },
  });
};
