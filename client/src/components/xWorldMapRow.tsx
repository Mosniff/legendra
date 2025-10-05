import { WorldMapTile } from "@/components/xWorldMapTile";
import type { GameWorld } from "@/types/gameTypes";

export const WorldMapRow = ({
  columnNumbers,
  rowNumber,
  world,
}: {
  columnNumbers: number[];
  rowNumber: number;
  world: GameWorld;
}) => {
  return (
    <div className="flex">
      {columnNumbers.map((columnNumber) => (
        <WorldMapTile
          key={columnNumber}
          rowNumber={rowNumber}
          columnNumber={columnNumber}
          world={world}
        />
      ))}
    </div>
  );
};
