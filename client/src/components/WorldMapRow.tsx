import { WorldMapTile } from "@/components/WorldMapTile";
import type { MapTile } from "@/types/gameTypes";

export const WorldMapRow = ({ tiles }: { tiles: MapTile[] }) => {
  return (
    <div className="flex">
      {tiles.map((tile) => (
        <WorldMapTile key={tile.id} {...tile} />
      ))}
    </div>
  );
};
