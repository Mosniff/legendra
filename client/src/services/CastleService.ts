import type { CastleService } from "@/types/serviceTypes";
import axios, { type AxiosResponse } from "axios";

const apiUrl = import.meta.env.VITE_API_URL;

export const castleService: CastleService = {
  createArmyFromGarrison: async (
    authToken: string,
    gameId: string,
    castleId: string,
    selectedGeneralIds: string[]
  ): Promise<AxiosResponse | null> => {
    try {
      return await axios.post(
        `${apiUrl}/games/${gameId}/create_army_from_garrison`,
        { castle_id: castleId, selected_general_ids: selectedGeneralIds },
        {
          headers: { Authorization: authToken },
        }
      );
    } catch (err) {
      console.log("error in createArmyFromGarrison", err);
      return null;
    }
  },

  addToArmyFromGarrison: async (
    authToken: string,
    gameId: string,
    castleId: string,
    armyId: string,
    selectedGeneralIds: string[]
  ): Promise<AxiosResponse | null> => {
    try {
      return await axios.patch(
        `${apiUrl}/games/${gameId}/add_to_army_from_garrison`,
        {
          castle_id: castleId,
          army_id: armyId,
          selected_general_ids: selectedGeneralIds,
        },
        {
          headers: { Authorization: authToken },
        }
      );
    } catch (err) {
      console.log("error in addToArmyFromGarrison", err);
      return null;
    }
  },
};
