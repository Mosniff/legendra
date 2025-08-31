import axios, { type AxiosResponse } from "axios";

const apiUrl = import.meta.env.VITE_API_URL;

export const createArmyFromGarrison = async (
  authToken: string,
  gameId: string,
  garrisonId: string,
  selectedGeneralIds: string[]
): Promise<AxiosResponse | null> => {
  try {
    return await axios.post(
      `${apiUrl}/games/${gameId}/create_army_from_garrison`,
      { garrison_id: garrisonId, selected_general_ids: selectedGeneralIds },
      {
        headers: { Authorization: authToken },
      }
    );
  } catch (err) {
    console.log("error in createArmyFromGarrison", err);
    return null;
  }
};
