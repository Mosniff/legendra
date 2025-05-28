import { useMutation } from "@tanstack/react-query";
import { useAuthContext } from "@/context/AuthContext";
import { useAppContext } from "@/context/AppContext";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import GameSelectSlab from "../GameSelectSlab";

export const GameSelectScreen = () => {
  const { state: authContextState, userService } = useAuthContext();

  const { data: user, isLoading, refetch: refetchUser } = useUserQuery();

  const createGameMutation = useMutation({
    mutationFn: (slot: number) =>
      userService.createGameForUser(authContextState.authToken!, slot),
    onSuccess: () => {
      refetchUser();
    },
  });

  const setActiveGameMutation = useMutation({
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

  const deleteGameMutation = useMutation({
    mutationFn: (id: string) =>
      userService.deleteGameForUser(authContextState.authToken!, id),
    onSuccess: () => {
      refetchUser();
    },
  });

  const { dispatch: appContextDispatch } = useAppContext();

  return (
    <div className="flex flex-col gap-2 h-full">
      <div>Games:</div>
      {isLoading && <div>Loading...</div>}
      {!isLoading && user && (
        <div className="flex flex-col gap-2 overflow-y-scroll flex-1">
          {[...Array(10)].map((_, i) => {
            let game = null;
            game = user?.gamesMetadata.find((g) => g.slot === i);
            return (
              <div key={i}>
                <GameSelectSlab
                  slotNumber={i}
                  game={game}
                  setActiveGameMutation={setActiveGameMutation}
                  deleteGameMutation={deleteGameMutation}
                  createGameMutation={createGameMutation}
                />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
