import { WorldMap } from "@/components/WorldMap";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import type { Game } from "@/types/gameTypes";
import { ScrollArea, ScrollBar } from "@/components/ui/scroll-area";
import { Thumb } from "@radix-ui/react-scroll-area";

export const WorldMapScreenPresentation = ({
  game,
  isLoadingGame,
}: {
  game?: Game | null;
  isLoadingGame: boolean;
}) => {
  console.log("game", game, isLoadingGame);
  return (
    <ScrollArea className="h-full w-full rounded-md border">
      {game && game.world && !isLoadingGame && (
        <WorldMap {...game.world.gameMap} />
      )}
      <ScrollBar orientation="horizontal">
        <Thumb />
      </ScrollBar>
      <ScrollBar orientation="vertical">
        <Thumb />
      </ScrollBar>
    </ScrollArea>
  );
};

export const WorldMapScreen = () => {
  const { data: game, isLoading: isLoadingGame } = useGameQuery();

  return (
    <WorldMapScreenPresentation game={game} isLoadingGame={isLoadingGame} />
  );
};
