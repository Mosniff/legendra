import type { Castle, Game, GameState, Town } from "@/types/gameTypes";

type GetGameApiResponseIncludedType =
  | { type: "world"; attributes: { id: string } }
  | { type: "map"; attributes: { id: string; width: number; height: number } }
  | {
      type: "tile";
      attributes: {
        id: string;
        x_coord: number;
        y_coord: number;
        terrain: string;
        castle?: Castle;
        town?: Town;
      };
    };
export interface GetGameApiResponse {
  data: {
    attributes: {
      id: string;
      slot: number;
      active: boolean;
      game_state: GameState;
    };
  };
  included: GetGameApiResponseIncludedType[];
}
export const getGameAdapter = (response: GetGameApiResponse): Game => {
  const worldResponse = response.included.find(
    (included) => included.type == "world"
  );
  let world = undefined;
  if (worldResponse) {
    world = { id: worldResponse.attributes.id };
  }

  const mapResponse = response.included.find(
    (included) => included.type == "map"
  );
  const tilesResponse = response.included.filter(
    (included) => included.type == "tile"
  );

  let map = undefined;
  if (mapResponse) {
    map = {
      id: mapResponse.attributes.id,
      width: mapResponse.attributes.width,
      height: mapResponse.attributes.height,
      tiles: tilesResponse.map((tile) => ({
        id: tile.attributes.id,
        xCoord: tile.attributes.x_coord,
        yCoord: tile.attributes.y_coord,
        terrain: tile.attributes.terrain,
        castle: tile.attributes.castle,
        town: tile.attributes.town,
      })),
    };
  }

  return {
    id: response.data.attributes.id,
    slot: response.data.attributes.slot,
    active: response.data.attributes.active,
    gameState: response.data.attributes.game_state,
    world: world,
    map: map,
  };
};
