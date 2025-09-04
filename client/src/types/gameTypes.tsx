export type Game = {
  id: string;
  slot: number;
  active: boolean;
  gameState: GameState;
  world?: GameWorld;
  turn: number;
};

export type GameState = "story_choice" | "in_progress";

export type GameWorld = {
  id: string;
  gameId: string;
  gameMap: GameMap;
  kingdoms: Kingdom[];
  generals: General[];
  castles: Castle[];
  towns: Town[];
  armies: Army[];
};

export type GameMap = {
  id: string;
  width: number;
  height: number;
  tiles: MapTile[];
};

export type MapTile = {
  id: string;
  xCoord: number;
  yCoord: number;
  terrain: string;
  routeTile: boolean;
  castleId?: string | null;
  townId?: string | null;
};

export type Castle = {
  id: string;
  name: string;
  isPlayerControlled: boolean;
  garrisonedGeneralIds: string[];
  xCoord: number;
  yCoord: number;
};

export type Town = {
  id: string;
  name: string;
  xCoord: number;
  yCoord: number;
};

export type Kingdom = {
  id: string;
  name: string;
  isPlayerKingdom: boolean;
};

export type General = {
  id: string;
  name: string;
  kingdomId?: string;
};

export type Army = {
  id: string;
  xCoord: number;
  yCoord: number;
  isPlayerControlled: boolean;
  kingdomId: string;
  generalIds: string[];
};

export type ScenarioTemplate = {
  key: string;
  title: string;
  stories: StoryTemplate[];
};
export type StoryTemplate = { key: string; title: string };
