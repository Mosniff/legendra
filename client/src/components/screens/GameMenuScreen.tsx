import { useAppContext } from "@/context/AppContext";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { WorldMap } from "@/components/WorldMap";
import { StoryChoice } from "../StoryChoice";

export const GameMenuScreen = ({}: {}) => {
  const { dispatch: appContextDispatch } = useAppContext();
  const { data: game, isLoading: isLoadingGame } = useGameQuery();

  return (
    <>
      {isLoadingGame && <div>Loading Game...</div>}
      {!isLoadingGame && game && (
        <div>
          <div>
            Game Id: {game.id} Game Slot: {game.slot + 1} Game State:{" "}
            {game.gameState} Map Tile Count: {game.map?.tiles.length || 0}
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
          {game.gameState === "story_choice" && <StoryChoice game={game} />}
          {game.gameState === "in_progress" && <WorldMap />}
        </div>
      )}
    </>
  );
};
