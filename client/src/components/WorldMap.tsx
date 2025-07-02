import type { Game } from "@/types/gameTypes";
import { WorldMapRow } from "@/components/WorldMapRow";

export const WorldMap = ({ game }: { game: Game }) => {
  const rowNumbers = Array.from(
    { length: game.map?.height || 0 },
    (_, index) => index
  );

  const columnNumbers = Array.from(
    { length: game.map?.height || 0 },
    (_, index) => index
  );

  return (
    <div>
      {game.map && (
        <>
          {rowNumbers.reverse().map((rowNumber) => (
            <WorldMapRow
              key={rowNumber}
              rowNumber={rowNumber}
              columnNumbers={columnNumbers}
            />
          ))}
        </>
      )}
    </div>
  );
};
