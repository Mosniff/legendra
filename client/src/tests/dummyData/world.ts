import type { GameWorld } from "@/types/gameTypes";
import { dummyGameMapSmall } from "@/tests/dummyData/gameMap";

export const dummyGameWorld: () => GameWorld = () => ({
  id: "1",
  gameId: "1",
  gameMap: dummyGameMapSmall,
  kingdoms: [],
  generals: [],
  castles: [],
  towns: [],
  armies: [],
});
