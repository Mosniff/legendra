import type { AxiosResponse } from "axios";

export type GameService = {
  getGame: (authToken: string, id: string) => Promise<Game | null>;
  getScenarioTemplates: (
    authToken: string
  ) => Promise<ScenarioTemplate[] | null>;
  setStoryForGame: (
    authToken: string,
    id: string,
    storyKey: string
  ) => Promise<AxiosResponse | null>;
};

export type Game = {
  id: string;
  slot: number;
  active: boolean;
  world?: GameWorld;
  map?: GameMap;
  gameState: string;
};

export type GameWorld = {
  id: string;
};
export type GameMap = {
  id: string;
  tiles: MapTile[];
};

export type MapTile = {
  xCoord: number;
  yCoord: number;
  terrain: string;
};

export type ScenarioTemplate = {
  key: string;
  title: string;
  stories: StoryTemplate[];
};
export type StoryTemplate = { key: string; title: string };
