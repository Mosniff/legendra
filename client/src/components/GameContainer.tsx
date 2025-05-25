import { useAppContext } from "@/context/AppContext";
import { GameMenuScreen } from "@/components/screens/GameMenuScreen";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";

export const GameContainer = () => {
  const { state: appContextState } = useAppContext();
  const { data: game, isLoading: isLoadingGame } = useGameQuery();

  return (
    <>
      {isLoadingGame && (
        <div>
          <h1>Loading Game...</h1>
        </div>
      )}
      {game && (
        <>
          {appContextState.currentScreen === "Game Menu" && <GameMenuScreen />}
        </>
      )}
    </>
  );
};
