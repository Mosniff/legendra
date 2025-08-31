import { useMutation } from "@tanstack/react-query";
import { useAuthContext } from "@/context/AuthContext";
import { useAppContext } from "@/context/AppContext";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";

export const useCreateArmyFromGarrisonMutation = () => {
  const { state: authContextState } = useAuthContext();
  const { castleService } = useAppContext();
  const { refetch: refetchGame } = useGameQuery();

  return useMutation({
    mutationFn: ({
      gameId,
      garrisonId,
      selectedGeneralIds,
    }: {
      gameId: string;
      garrisonId: string;
      selectedGeneralIds: string[];
    }) =>
      castleService.createArmyFromGarrison(
        authContextState.authToken!,
        gameId,
        garrisonId,
        selectedGeneralIds
      ),
    onSuccess: () => {
      refetchGame();
    },
  });
};
