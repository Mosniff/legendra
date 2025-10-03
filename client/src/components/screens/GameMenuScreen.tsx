import { useAppContext } from "@/context/AppContext";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import { AppContextActionTypes } from "@/types/appContextTypes";
import { WorldMap } from "@/components/WorldMap";
import { StoryChoice } from "@/components/StoryChoice";
import { KingdomsList } from "@/components/KingdomsList";
import { CastlesList } from "@/components/CastlesList";
import { ArmiesList } from "@/components/ArmiesList";
import { useAdvanceTurnForGameMutation } from "@/services/mutationHooks/gameMutationHooks";

export const GameMenuScreen = ({}: {}) => {
  const advanceGameMutation = useAdvanceTurnForGameMutation();
  const { dispatch: appContextDispatch } = useAppContext();
  const { data: game, isLoading: isLoadingGame } = useGameQuery();

  return (
    <>
      {isLoadingGame && <div>Loading Game...</div>}
      {!isLoadingGame && game && (
        <div>
          <div>
            Game Id: {game.id} Game Slot: {game.slot + 1} Game State:{" "}
            {game.gameState} Map Tile Count:{" "}
            {game.world?.gameMap?.tiles.length || 0}
            Turn: {game.turn}
            <button
              onClick={() => {
                advanceGameMutation.mutate(game.id);
              }}
            >
              Advance Turn
            </button>
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
          {game.gameState !== "story_choice" && game.world && (
            <>
              <WorldMap world={game.world} />
              <div className="flex gap-2">
                <KingdomsList world={game.world} />
                <CastlesList world={game.world} />
                <ArmiesList world={game.world} />
              </div>
            </>
          )}
        </div>
      )}
    </>
  );
};
