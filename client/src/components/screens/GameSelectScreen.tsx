import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes, type User } from "@/types/authContextTypes";
import { useEffect } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";

export const GameSelectScreen = () => {
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

  const {
    data: user,
    isLoading,
    refetch,
  } = useQuery<User>({
    queryKey: ["user"],
  });

  const createGameMutation = useMutation({
    mutationFn: (slot: number) =>
      userService.createGame(authContextState.authToken!, slot),
    onSuccess: () => {
      refetch();
    },
  });
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
                  <p>
                    Slot {i + 1}: Game {game.id}
                  </p>
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
