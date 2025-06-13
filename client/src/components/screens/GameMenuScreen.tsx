import { useAppContext } from "@/context/AppContext";
import { useSetStoryForGameMutation } from "@/services/mutationHooks/gameMutationHooks";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import { useScenarioTemplatesQuery } from "@/services/queryHooks/useScenarioTemplatesQuery";
import { AppContextActionTypes } from "@/types/appContextTypes";

export const GameMenuScreen = ({}: {}) => {
  const { dispatch: appContextDispatch } = useAppContext();
  const { data: game, isLoading: isLoadingGame } = useGameQuery();

  // Get list of scenarios if game is in story_choice state
  const { data: scenarioTemplates, isLoading: isLoadingScenarios } =
    useScenarioTemplatesQuery({
      enabled: !!game && game.gameState === "story_choice",
    });

  const setStoryForGameMutation = useSetStoryForGameMutation();

  return (
    <>
      {isLoadingGame && <div>Loading Game...</div>}
      {!isLoadingGame && game && (
        <div>
          <div>
            Game Id: {game.id} Game Slot: {game.slot + 1} Game State:{" "}
            {game.gameState}
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
          {game.gameState === "story_choice" && (
            <div>
              {isLoadingScenarios && <div>Loading Scenarios...</div>}
              <div>Choose scenario:</div>
              {scenarioTemplates?.map((scenarioTemplate) => (
                <div className="ml-2" key={scenarioTemplate.title}>
                  <div>{scenarioTemplate.title} -</div>
                  <ul className="ml-2">
                    {scenarioTemplate.stories.map((story) => (
                      <li key={story.key} className="flex gap-2">
                        <span>{story.title}</span>
                        <button
                          className="border p-1"
                          onClick={() => {
                            setStoryForGameMutation.mutate({
                              id: game.id,
                              storyKey: story.key,
                            });
                          }}
                        >
                          Choose story
                        </button>
                      </li>
                    ))}
                  </ul>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </>
  );
};
