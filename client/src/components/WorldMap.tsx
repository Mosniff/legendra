import type { GameMap } from "@/types/gameTypes";
import { WorldMapRow } from "@/components/WorldMapRow";

export const WorldMap = ({ height, tiles }: GameMap) => {
  return (
    <>
      {Array.from({ length: height }).map((_, i) => (
        <WorldMapRow key={i} tiles={tiles.filter((tile) => tile.yCoord == i)} />
      ))}
    </>
  );
};
