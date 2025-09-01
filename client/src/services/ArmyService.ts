import axios, { type AxiosResponse } from "axios";

const apiUrl = import.meta.env.VITE_API_URL;

export const addToGarrisonFromArmy = async (
  authToken: string,
  gameId: string,
  armyId: string,
  selectedGeneralIds: string[]
): Promise<AxiosResponse | null> => {
  try {
    return await axios.patch(
      `${apiUrl}/games/${gameId}/add_to_garrison_from_army`,
      { army_id: armyId, selected_general_ids: selectedGeneralIds },
      {
        headers: { Authorization: authToken },
      }
    );
  } catch (err) {
    console.log("error in addToGarrisonFromArmy", err);
    return null;
  }
};
