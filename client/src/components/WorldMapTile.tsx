import { useGameQuery } from "@/services/queryHooks/useGameQuery";
import { useEffect, useState } from "react";
import { type MapTile } from "@/types/gameTypes";

export const WorldMapTile = ({
  rowNumber,
  columnNumber,
}: {
  rowNumber: number;
  columnNumber: number;
}) => {
  const { data: game } = useGameQuery();
  const [tile, setTile] = useState<MapTile | null>();
  useEffect(() => {
    const foundTile = game?.map?.tiles.find(
      (tile) => tile.xCoord === rowNumber && tile.yCoord === columnNumber
    );
    setTile(foundTile);
  }, [game]);

  const terrainColors: { [key: string]: string } = {
    desert: "bg-yellow-100",
    grassland: "bg-green-500",
    snow: "bg-gray-100",
  };

  return (
    <>
      {tile && (
        <div className={`h-8 w-8 border  ${terrainColors[tile.terrain]}`} />
      )}
    </>
  );
};
