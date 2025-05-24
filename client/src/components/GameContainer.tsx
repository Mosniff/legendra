import { useAppContext } from "@/context/AppContext";
import { GameMenuScreen } from "@/components/screens/GameMenuScreen";
import { useAuthContext } from "@/context/AuthContext";
import type { Game } from "@/types/appContextTypes";
import { useQuery } from "@tanstack/react-query";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";

export const GameContainer = () => {
  const { state: authContextState } = useAuthContext();
  const { state: appContextState, gameService } = useAppContext();
  const { data: user } = useUserQuery();

  const { data: game, isLoading: isLoadingGame } = useQuery<Game | null>({
    queryKey: ["game"],
    queryFn: () =>
      user?.activeGameId
        ? gameService.getGame(authContextState.authToken!, user.activeGameId)
        : Promise.resolve(null),
    enabled: !!authContextState.authToken,
  });

  return (
    <>
      {isLoadingGame && (
        <div>
          <h1>Loading Game...</h1>
        </div>
      )}
      {game && (
        <>
          {appContextState.currentScreen === "Game Menu" && (
            <GameMenuScreen game={game} />
          )}
        </>
      )}
    </>
  );
};
