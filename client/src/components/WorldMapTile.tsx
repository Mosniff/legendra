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
      (tile) => tile.xCoord === columnNumber && tile.yCoord === rowNumber
    );
    setTile(foundTile);
    console.log(tile);
  }, [game]);

  const terrainColors: { [key: string]: string } = {
    desert: "bg-yellow-100",
    grassland: "bg-green-500",
    snow: "bg-gray-100",
  };

  return (
    <>
      {tile && (
        <div
          className={`h-8 w-8 border flex justify-center items-center ${
            terrainColors[tile.terrain]
          }`}
          title={`Tile at X:${tile.xCoord}, Y:${tile.yCoord}`}
        >
          {tile.castle && (
            <div
              className="h-4 w-4 bg-gray-600"
              title={`${tile.castle.name} Castle`}
            />
          )}
          {tile.town && (
            <div
              className="h-4 w-4 bg-amber-700"
              title={`${tile.town.name} Town`}
            />
          )}
          {tile.routeTile && <div className="h-2 w-2 bg-yellow-300" />}
        </div>
      )}
    </>
  );
};
