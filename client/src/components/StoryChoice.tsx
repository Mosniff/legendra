import { useSetStoryForGameMutation } from "@/services/mutationHooks/gameMutationHooks";
import { useScenarioTemplatesQuery } from "@/services/queryHooks/useScenarioTemplatesQuery";
import type { Game } from "@/types/gameTypes";

export const StoryChoice = ({ game }: { game: Game }) => {
  const { data: scenarioTemplates, isLoading: isLoadingScenarios } =
    useScenarioTemplatesQuery({
      enabled: !!game && game.gameState === "story_choice",
    });

  const setStoryForGameMutation = useSetStoryForGameMutation();

  return (
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
  );
};
