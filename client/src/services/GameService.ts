import type { Game } from "@/types/appContextTypes";
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
    };
  } catch (err) {
    console.log("error in getGame", err);
    return null;
  }
};
