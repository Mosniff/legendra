import { useEffect } from "react";
import { useMutation } from "@tanstack/react-query";
import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useAppContext } from "@/context/AppContext";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";

export const GameSelectScreen = () => {
  const {
    state: authContextState,
    dispatch: authContextDispatch,
    userService,
  } = useAuthContext();
  useEffect(() => {
    const storedToken = localStorage.getItem("authToken");
    if (storedToken && authContextState.authToken !== storedToken) {
      authContextDispatch({
        type: AuthContextActionTypes.SET_AUTH_TOKEN,
        payload: storedToken,
      });
    }
  }, []);

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
    <>
      <div>Games:</div>
      {isLoading && <div>Loading...</div>}
      {!isLoading && user && (
        <div>
          {[...Array(10)].map((_, i) => {
            let game = null;
            game = user?.gamesMetadata.find((g) => g.slot === i);
            return (
              <div key={i}>
                {game ? (
                  <div>
                    <p>
                      Slot {i + 1}: Game {game.id}{" "}
                      {game.active ? "(Active)" : "(Inactive)"}
                    </p>
                    <button
                      onClick={() => {
                        setActiveGameMutation.mutate(game.id);
                      }}
                    >
                      Goto Game
                    </button>
                    <button
                      onClick={() => {
                        deleteGameMutation.mutate(game.id);
                      }}
                    >
                      Delete Game
                    </button>
                  </div>
                ) : (
                  <div className="flex gap-1">
                    <p>Slot {i + 1}: Empty</p>
                    <button
                      onClick={() => {
                        createGameMutation.mutate(i);
                      }}
                      disabled={createGameMutation.isPending}
                    >
                      {createGameMutation.isPending ? "Creating..." : "Create"}
                    </button>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </>
  );
};
