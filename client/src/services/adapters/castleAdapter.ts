import type { Castle } from "@/types/gameTypes";
import {
  type GeneralApiResponseType,
  generalAdapter,
} from "@/services/adapters/generalAdapter";

export type CastleApiResponseType = {
  id: string;
  name: string;
  garrisoned_generals: GeneralApiResponseType[];
  player_controlled: boolean;
};

export const castleAdapter = (response: CastleApiResponseType): Castle => {
  return {
    id: response.id,
    name: response.name,
    garrisonedGenerals: response.garrisoned_generals
      ? response.garrisoned_generals.map((general) => generalAdapter(general))
      : [],
    isPlayerControlled: response.player_controlled,
  };
};
