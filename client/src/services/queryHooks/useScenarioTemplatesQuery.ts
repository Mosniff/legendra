// useScenarioTemplatesQuery.ts
import { useAppContext } from "@/context/AppContext";
import { useAuthContext } from "@/context/AuthContext";
import type { ScenarioTemplate } from "@/types/gameTypes";
import { useQuery, type UseQueryResult } from "@tanstack/react-query";

type useScenarioTemplatesQueryOptions = { enabled?: boolean };

export const useScenarioTemplatesQuery = ({
  enabled = true,
}: useScenarioTemplatesQueryOptions): UseQueryResult<
  ScenarioTemplate[] | null,
  Error
> => {
  const { gameService } = useAppContext();
  const { state: authContextState } = useAuthContext();
  return useQuery<ScenarioTemplate[] | null>({
    queryKey: ["scenarioTemplates"],
    queryFn: () =>
      gameService.getScenarioTemplates(authContextState.authToken!),
    staleTime: Infinity,
    enabled: enabled,
  });
};
