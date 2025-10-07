import type { Castle, GameMap, MapTile, Town } from "@/types/gameTypes";

export const dummyCastle: Castle = {
  id: "castle-1",
  name: "Castle 1",
  isPlayerControlled: false,
  garrisonedGeneralIds: [],
  xCoord: 0,
  yCoord: 0,
};

export const dummyTown: Town = {
  id: "town-1",
  name: "Town 1",
  xCoord: 0,
  yCoord: 0,
};

export const dummyMapTile: (options?: {
  withCastle?: boolean;
  withTown?: boolean;
  xCoord?: number;
  yCoord?: number;
  terrain?: string;
  isRouteTile?: boolean;
}) => MapTile = (options) => ({
  id: "1",
  xCoord: options?.xCoord ?? 0,
  yCoord: options?.yCoord ?? 0,
  terrain: options?.terrain ?? "grassland",
  routeTile: options?.isRouteTile ?? false,
  castle: options?.withCastle ? dummyCastle : null,
  town: options?.withTown ? dummyTown : null,
});

export const dummyGameMap: (options: {
  height: number;
  width: number;
  overrideTiles?: MapTile[];
}) => GameMap = (options) => {
  const tiles: MapTile[] = [];
  for (let y = 0; y < options.height; y++) {
    for (let x = 0; x < options.width; x++) {
      tiles.push(dummyMapTile({ xCoord: x, yCoord: y }));
    }
  }

  options.overrideTiles?.forEach((overrideTile) => {
    const index = tiles.findIndex(
      (t) =>
        t.xCoord === overrideTile.xCoord && t.yCoord === overrideTile.yCoord
    );

    if (index !== -1) {
      tiles[index] = overrideTile;
    }
  });

  return {
    id: "map-1",
    width: options.width,
    height: options.height,
    tiles: tiles,
  };
};

export const dummyGameMapSmall = dummyGameMap({
  height: 20,
  width: 20,
  overrideTiles: [
    dummyMapTile({ xCoord: 0, yCoord: 0, terrain: "snow", withCastle: true }),
    dummyMapTile({
      xCoord: 1,
      yCoord: 0,
      terrain: "snow",
      isRouteTile: true,
    }),
    dummyMapTile({ xCoord: 0, yCoord: 1, terrain: "snow" }),
    dummyMapTile({
      xCoord: 1,
      yCoord: 1,
      terrain: "snow",
      isRouteTile: true,
    }),
    dummyMapTile({
      xCoord: 2,
      yCoord: 0,
      terrain: "snow",
      isRouteTile: true,
    }),
    dummyMapTile({
      xCoord: 3,
      yCoord: 0,
      terrain: "snow",
      isRouteTile: true,
    }),
    dummyMapTile({
      xCoord: 4,
      yCoord: 0,
      terrain: "snow",
      isRouteTile: true,
    }),
    dummyMapTile({ xCoord: 0, yCoord: 2, terrain: "snow" }),
    dummyMapTile({ xCoord: 5, yCoord: 0, withTown: true }),
    dummyMapTile({
      xCoord: 5,
      yCoord: 5,
      terrain: "desert",
      withCastle: true,
    }),
    dummyMapTile({ xCoord: 5, yCoord: 6, terrain: "desert" }),
    dummyMapTile({ xCoord: 5, yCoord: 7, terrain: "desert" }),
    dummyMapTile({ xCoord: 6, yCoord: 5, terrain: "desert" }),
    dummyMapTile({ xCoord: 6, yCoord: 6, terrain: "desert" }),
    dummyMapTile({ xCoord: 7, yCoord: 5, terrain: "desert" }),
    dummyMapTile({ xCoord: 7, yCoord: 6, terrain: "desert" }),
    dummyMapTile({ xCoord: 2, yCoord: 2, isRouteTile: true }),
    dummyMapTile({ xCoord: 3, yCoord: 3, isRouteTile: true }),
    dummyMapTile({ xCoord: 4, yCoord: 4, isRouteTile: true }),
    dummyMapTile({ xCoord: 5, yCoord: 1, isRouteTile: true }),
    dummyMapTile({ xCoord: 5, yCoord: 2, isRouteTile: true }),
    dummyMapTile({ xCoord: 5, yCoord: 3, isRouteTile: true }),
    dummyMapTile({ xCoord: 5, yCoord: 4, isRouteTile: true }),
  ],
});
