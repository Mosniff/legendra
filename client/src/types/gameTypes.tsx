export type Game = {
  id: string;
  slot: number;
  active: boolean;
  world?: GameWorld;
  gameMap?: GameMap;
  gameState: GameState;
  kingdoms: Kingdom[];
  generals: General[];
};

export type GameState = "story_choice" | "in_progress";

export type GameWorld = {
  id: string;
};
export type GameMap = {
  id: string;
  tiles: MapTile[];
  width: number;
  height: number;
  castles: Castle[];
};

export type MapTile = {
  id: string;
  xCoord: number;
  yCoord: number;
  terrain: string;
  castle?: Castle | null;
  town?: Town | null;
  routeTile: boolean;
};

export type Castle = {
  id: string;
  name: string;
  garrisonedGenerals: General[];
  isPlayerControlled: boolean;
};

export type Town = {
  id: string;
  name: string;
};

export type Kingdom = {
  id: string;
  name: string;
};

export type General = {
  id: string;
  kingdomId?: string;
  name: string;
};

export type ScenarioTemplate = {
  key: string;
  title: string;
  stories: StoryTemplate[];
};
export type StoryTemplate = { key: string; title: string };
