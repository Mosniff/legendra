import type { Game, ScenarioTemplate } from "@/types/gameTypes";
import axios from "axios";

const apiUrl = import.meta.env.VITE_API_URL;

export const getGame = async (
  authToken: string,
  id: string
): Promise<Game | null> => {
  try {
    const response = await axios.get(`${apiUrl}/games/${id}`, {
      headers: { Authorization: authToken },
    });
    console.log("response in getGame", response);
    return {
      id: response.data.id,
      slot: response.data.slot,
      active: response.data.active,
      world: {},
      gameState: response.data.game_state,
    };
  } catch (err) {
    console.log("error in getGame", err);
    return null;
  }
};

export const getScenarioTemplates = async (
  authToken: string
): Promise<ScenarioTemplate[] | null> => {
  try {
    const response = await axios.get(`${apiUrl}/games/scenario_templates`, {
      headers: { Authorization: authToken },
    });
    console.log("response in getScenarioTemplates", response);
    return response.data;
  } catch (err) {
    console.log("error in getScenarioTemplates", err);
    return null;
  }
};
