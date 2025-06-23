import type { Game } from "@/types/gameTypes";

type GetGameApiResponseIncludedType =
  | { type: "world"; attributes: { id: string } }
  | { type: "map"; attributes: { id: string } }
  | {
      type: "tile";
      attributes: { x_coord: number; y_coord: number; terrain: string };
    };
export interface GetGameApiResponse {
  data: {
    attributes: {
      id: string;
      slot: number;
      active: boolean;
      game_state: string;
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
      tiles: tilesResponse.map((tile) => ({
        xCoord: tile.attributes.x_coord,
        yCoord: tile.attributes.y_coord,
        terrain: tile.attributes.terrain,
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
