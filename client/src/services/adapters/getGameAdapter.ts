import type { Game, GameState, Town } from "@/types/gameTypes";
import {
  type GeneralApiResponseType,
  generalAdapter,
} from "@/services/adapters/generalAdapter";
import {
  type CastleApiResponseType,
  castleAdapter,
} from "@/services/adapters/castleAdapter";

type GetGameApiResponseIncludedType =
  | { type: "world"; attributes: { id: string } }
  | {
      type: "map";
      attributes: {
        id: string;
        width: number;
        height: number;
        castles: CastleApiResponseType[];
      };
    }
  | {
      type: "tile";
      attributes: {
        id: string;
        x_coord: number;
        y_coord: number;
        terrain: string;
        castle?: CastleApiResponseType;
        town?: Town;
        is_route_tile: boolean;
      };
    }
  | {
      type: "kingdom";
      attributes: {
        id: string;
        name: string;
      };
    }
  | {
      type: "general";
      attributes: GeneralApiResponseType;
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
        castle: tile.attributes.castle
          ? castleAdapter(tile.attributes.castle)
          : undefined,
        town: tile.attributes.town,
        routeTile: tile.attributes.is_route_tile,
      })),
      castles: mapResponse.attributes.castles.map((apiCastle) => {
        return castleAdapter(apiCastle);
      }),
    };
  }

  const kingdomsResponse = response.included.filter(
    (included) => included.type == "kingdom"
  );
  const kingdoms = kingdomsResponse.map((kingdom) => {
    return {
      id: kingdom.attributes.id,
      name: kingdom.attributes.name,
    };
  });

  const generalsResponse = response.included.filter(
    (included) => included.type == "general"
  );
  const generals = generalsResponse.map((response) => {
    return generalAdapter(response.attributes);
  });

  return {
    id: response.data.attributes.id,
    slot: response.data.attributes.slot,
    active: response.data.attributes.active,
    gameState: response.data.attributes.game_state,
    world: world,
    map: map,
    kingdoms: kingdoms,
    generals: generals,
  };
};
