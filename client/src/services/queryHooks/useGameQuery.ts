import { useAppContext } from "@/context/AppContext";
import { useAuthContext } from "@/context/AuthContext";
import type { Game } from "@/types/gameTypes";
import { useQuery, type UseQueryResult } from "@tanstack/react-query";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";

export const useGameQuery = (): UseQueryResult<Game | null, Error> => {
  const { data: user } = useUserQuery();
  const { state: authContextState } = useAuthContext();
  const { gameService } = useAppContext();
  return useQuery<Game | null>({
    queryKey: ["game"],
    queryFn: () =>
      gameService.getGame(authContextState.authToken!, user?.activeGameId!),
    enabled: !!authContextState.authToken && !!user?.activeGameId,
  });
};
