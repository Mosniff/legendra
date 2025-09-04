import type { Game, ScenarioTemplate } from "@/types/gameTypes";
import axios, { type AxiosResponse } from "axios";
import {
  type GetGameApiResponse,
  getGameAdapter,
} from "@/services/adapters/getGameAdapter";

const apiUrl = import.meta.env.VITE_API_URL;

export const getGame = async (
  authToken: string,
  id: string
): Promise<Game | null> => {
  try {
    const response = await axios.get<GetGameApiResponse>(
      `${apiUrl}/games/${id}`,
      {
        headers: { Authorization: authToken },
      }
    );
    console.log("response in getGame", response);
    return getGameAdapter(response.data, id);
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

export const setStoryForGame = async (
  authToken: string,
  id: string,
  storyKey: string
): Promise<AxiosResponse | null> => {
  try {
    return await axios.patch(
      `${apiUrl}/games/${id}/set_story`,
      { story_key: storyKey },
      {
        headers: { Authorization: authToken },
      }
    );
  } catch (err) {
    console.log("error in setStoryForGame", err);
    return null;
  }
};

export const advanceTurnForGame = async (
  authToken: string,
  id: string
): Promise<AxiosResponse | null> => {
  try {
    return await axios.patch(
      `${apiUrl}/games/${id}/advance_turn`,
      {},
      {
        headers: { Authorization: authToken },
      }
    );
  } catch (err) {
    console.log("error in advanceTurnForGame", err);
    return null;
  }
};
