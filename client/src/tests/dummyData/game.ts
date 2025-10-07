import type { Game } from "@/types/gameTypes";
import { dummyGameWorld } from "@/tests/dummyData/world";
import type { GetGameApiResponse } from "@/services/adapters/getGameAdapter";

export const dummyGame: () => Game = () => ({
  id: "1",
  slot: 1,
  active: true,
  gameState: "orders_phase",
  world: dummyGameWorld(),
  turn: 1,
});

export const dummyGetGameApiResponse: () => GetGameApiResponse = () => ({
  data: {
    attributes: {
      id: "1",
      slot: 1,
      active: true,
      game_state: "orders_phase",
      turn: 1,
    },
  },
  included: [],
});
