import type { General } from "@/types/gameTypes";

export type GeneralApiResponseType = {
  id: string;
  name: string;
  kingdom_id: string;
};

export const generalAdapter = (response: GeneralApiResponseType): General => {
  return {
    id: response.id,
    name: response.name,
    kingdomId: response.kingdom_id,
  };
};
