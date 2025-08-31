import { useAppContext } from "@/context/AppContext";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { WorldMap } from "@/components/WorldMap";
import { StoryChoice } from "@/components/StoryChoice";
import { KingdomsList } from "@/components/KingdomsList";
import { CastlesList } from "@/components/CastlesList";

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
            {game.gameState} Map Tile Count: {game.gameMap?.tiles.length || 0}
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
          {game.gameState === "in_progress" && (
            <>
              <WorldMap game={game} />
              <div className="flex gap-2">
                <KingdomsList game={game} />
                {game.gameMap && <CastlesList game={game} />}
              </div>
            </>
          )}
        </div>
      )}
    </>
  );
};
