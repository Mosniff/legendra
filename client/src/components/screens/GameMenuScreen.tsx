import { useAppContext } from "@/context/AppContext";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import { AppContextActionTypes } from "@/types/appContextTypes";

export const GameMenuScreen = ({}: {}) => {
  const { dispatch: appContextDispatch } = useAppContext();
  const { data: game, isLoading: isLoadingGame } = useGameQuery();
  return (
    <>
      {isLoadingGame && <div>Loading Game...</div>}
      {!isLoadingGame && game && (
        <div>
          <div>
            Game Id: {game.id} Game Slot: {game.slot + 1}
          </div>
          <button
            onClick={() => {
              appContextDispatch({
                type: AppContextActionTypes.SET_SCREEN,
                payload: "Game Select",
              });
            }}
          >
            Back to Game Select
          </button>
        </div>
      )}
    </>
  );
};
