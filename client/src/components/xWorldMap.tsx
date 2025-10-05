import type { GameWorld } from "@/types/gameTypes";
import { WorldMapRow } from "@/components/xWorldMapRow";

export const WorldMap = ({ world }: { world: GameWorld }) => {
  const rowNumbers = Array.from(
    { length: world.gameMap.height || 0 },
    (_, index) => index
  );

  const columnNumbers = Array.from(
    { length: world.gameMap.height || 0 },
    (_, index) => index
  );

  return (
    <div>
      {rowNumbers.reverse().map((rowNumber) => (
        <WorldMapRow
          key={rowNumber}
          rowNumber={rowNumber}
          columnNumbers={columnNumbers}
          world={world}
        />
      ))}
    </div>
  );
};
