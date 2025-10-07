import type { GameService } from "@/types/serviceTypes";
import {
  type GetGameApiResponse,
  getGameAdapter,
} from "@/services/adapters/getGameAdapter";
import type { Game } from "@/types/gameTypes";
import { dummyGetGameApiResponse } from "@/tests/dummyData/game";

// WIP
export const dummyGameService: GameService = {
  getGame: async (_authToken: string, id: string): Promise<Game | null> => {
    return getGameAdapter(dummyGetGameApiResponse(), id);
  },
};
