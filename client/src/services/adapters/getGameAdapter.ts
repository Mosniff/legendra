import type {
  Army,
  Castle,
  Game,
  GameMap,
  GameState,
  GameWorld,
  General,
  Kingdom,
  Town,
} from "@/types/gameTypes";

type GetGameApiResponseIncludedType =
  | { type: "world"; id: string }
  | {
      type: "map";
      id: string;
      attributes: {
        width: number;
        height: number;
      };
    }
  | {
      type: "tile";
      id: string;
      attributes: {
        x_coord: number;
        y_coord: number;
        terrain: string;
        is_route_tile: boolean;
      };
      relationships: {
        castle: { data: { id: string; type: "castle" } | null };
        town: { data: { id: string; type: "town" } | null };
      };
    }
  | {
      type: "kingdom";
      id: string;
      attributes: {
        name: string;
        is_player_kingdom: boolean;
      };
    }
  | {
      type: "general";
      id: string;
      attributes: {
        name: string;
      };
      relationships: {
        kingdom: { data: { id: string; type: "kingdom" } | null };
      };
    }
  | {
      type: "army";
      id: string;
      relationships: {
        generals: { data: { id: string; type: "general" }[] };
        kingdom: { data: { id: string; type: "kingdom" } };
      };
      attributes: {
        x_coord: number;
        y_coord: number;
        player_controlled: boolean;
      };
    }
  | {
      type: "castle";
      id: string;
      attributes: {
        name: string;
        player_controlled: boolean;
        x_coord: number;
        y_coord: number;
      };
      relationships: {
        generals: { data: { id: string; type: "general" }[] };
      };
    }
  | {
      type: "town";
      id: string;
      attributes: {
        name: string;
        x_coord: number;
        y_coord: number;
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
export const getGameAdapter = (
  response: GetGameApiResponse,
  gameId: string
): Game => {
  const mapResponse = response.included.find(
    (included) => included.type == "map"
  );
  const tilesResponse = response.included.filter(
    (included) => included.type == "tile"
  );

  let gameMap: GameMap | undefined = undefined;
  if (mapResponse) {
    gameMap = {
      id: mapResponse.id,
      width: mapResponse.attributes.width,
      height: mapResponse.attributes.height,
      tiles: tilesResponse.map((tile) => ({
        id: tile.id,
        xCoord: tile.attributes.x_coord,
        yCoord: tile.attributes.y_coord,
        terrain: tile.attributes.terrain,
        castleId: tile.relationships.castle.data?.id,
        townId: tile.relationships.town.data?.id,
        routeTile: tile.attributes.is_route_tile,
      })),
    };
  }

  const kingdomsResponse = response.included.filter(
    (included) => included.type == "kingdom"
  );
  const kingdoms: Kingdom[] = kingdomsResponse.map((kingdom) => {
    return {
      id: kingdom.id,
      name: kingdom.attributes.name,
      isPlayerKingdom: kingdom.attributes.is_player_kingdom,
    };
  });

  const generalsResponse = response.included.filter(
    (included) => included.type == "general"
  );
  const generals: General[] = generalsResponse.map((general) => {
    return {
      id: general.id,
      name: general.attributes.name,
      kingdomId: general.relationships.kingdom.data?.id,
    };
  });

  const armiesResponse = response.included.filter(
    (included) => included.type == "army"
  );
  const armies: Army[] = armiesResponse.map((army) => {
    return {
      id: army.id,
      kingdomId: army.relationships.kingdom.data.id,
      generalIds: army.relationships.generals.data.map((general) => general.id),
      xCoord: army.attributes.x_coord,
      yCoord: army.attributes.y_coord,
      isPlayerControlled: army.attributes.player_controlled,
    };
  });

  const castlesResponse = response.included.filter(
    (included) => included.type == "castle"
  );
  const castles: Castle[] = castlesResponse.map((castle) => {
    return {
      id: castle.id,
      name: castle.attributes.name,
      isPlayerControlled: castle.attributes.player_controlled,
      garrisonedGeneralIds: castle.relationships.generals.data.map(
        (general) => general.id
      ),
      xCoord: castle.attributes.x_coord,
      yCoord: castle.attributes.y_coord,
    };
  });

  const townsResponse = response.included.filter(
    (included) => included.type == "town"
  );
  const towns: Town[] = townsResponse.map((town) => {
    return {
      id: town.id,
      name: town.attributes.name,
      xCoord: town.attributes.x_coord,
      yCoord: town.attributes.y_coord,
    };
  });

  const worldResponse = response.included.find(
    (included) => included.type == "world"
  );
  let world: GameWorld | undefined = undefined;
  if (worldResponse && gameMap) {
    world = {
      id: worldResponse.id,
      gameId: gameId,
      gameMap: gameMap,
      kingdoms: kingdoms,
      generals: generals,
      armies: armies,
      castles: castles,
      towns: towns,
    };
  }

  return {
    id: response.data.attributes.id,
    slot: response.data.attributes.slot,
    active: response.data.attributes.active,
    gameState: response.data.attributes.game_state,
    world: world,
  };
};
