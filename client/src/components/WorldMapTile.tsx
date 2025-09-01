import { useEffect, useState } from "react";
import {
  type Army,
  type Castle,
  type GameWorld,
  type MapTile,
  type Town,
} from "@/types/gameTypes";

export const WorldMapTile = ({
  rowNumber,
  columnNumber,
  world,
}: {
  rowNumber: number;
  columnNumber: number;
  world: GameWorld;
}) => {
  const [tile, setTile] = useState<MapTile | null>();
  const [castle, setCastle] = useState<Castle | null>();
  const [town, setTown] = useState<Town | null>();
  const [armies, setArmies] = useState<Army[]>([]);
  useEffect(() => {
    const foundTile = world.gameMap.tiles.find(
      (tile) => tile.xCoord === columnNumber && tile.yCoord === rowNumber
    );
    setTile(foundTile);
    if (foundTile?.castleId) {
      const foundCastle = world.castles.find(
        (castle) => castle.id === foundTile.castleId
      );
      setCastle(foundCastle);
    }
    if (foundTile?.townId) {
      const foundTown = world.towns.find(
        (town) => town.id === foundTile.townId
      );
      setTown(foundTown);
    }
    if (foundTile) {
      const foundArmies = world.armies.filter(
        (army) => army.xCoord === columnNumber && army.yCoord === rowNumber
      );
      setArmies(foundArmies);
    }
  }, [world]);

  const terrainColors: { [key: string]: string } = {
    desert: "bg-yellow-100",
    grassland: "bg-green-500",
    snow: "bg-gray-100",
  };

  return (
    <>
      {tile && (
        <div
          className={`h-8 w-8 border flex justify-center items-center relative ${
            terrainColors[tile.terrain]
          }`}
          title={`Tile at X:${tile.xCoord}, Y:${tile.yCoord}`}
        >
          {/* Tile Feature */}
          <div>
            {castle && (
              <div
                className="h-4 w-4 bg-gray-600"
                title={`${castle.name} Castle`}
              />
            )}
            {town && (
              <div
                className="h-4 w-4 bg-amber-700"
                title={`${town.name} Town`}
              />
            )}
            {tile.routeTile && <div className="h-2 w-2 bg-yellow-300" />}
          </div>
          {/* Armies Slot */}
          <div className="absolute bottom-0 right-0 mb-0.5 mr-0.5 flex gap-1">
            {armies.map((_army) => (
              <div className="h-1 w-1 bg-fuchsia-500"></div>
            ))}
          </div>
        </div>
      )}
    </>
  );
};
