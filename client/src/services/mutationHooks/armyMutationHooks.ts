import { useMutation } from "@tanstack/react-query";
import { useAuthContext } from "@/context/AuthContext";
import { useAppContext } from "@/context/AppContext";
import { useGameQuery } from "@/services/queryHooks/useGameQuery";

export const useAddToGarrisonFromArmyMutation = () => {
  const { state: authContextState } = useAuthContext();
  const { armyService } = useAppContext();
  const { refetch: refetchGame } = useGameQuery();

  return useMutation({
    mutationFn: ({
      gameId,
      armyId,
      selectedGeneralIds,
    }: {
      gameId: string;
      armyId: string;
      selectedGeneralIds: string[];
    }) =>
      armyService.addToGarrisonFromArmy(
        authContextState.authToken!,
        gameId,
        armyId,
        selectedGeneralIds
      ),
    onSuccess: () => {
      refetchGame();
    },
  });
};
