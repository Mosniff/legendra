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
      castleId,
      selectedGeneralIds,
    }: {
      gameId: string;
      castleId: string;
      selectedGeneralIds: string[];
    }) =>
      castleService.createArmyFromGarrison(
        authContextState.authToken!,
        gameId,
        castleId,
        selectedGeneralIds
      ),
    onSuccess: () => {
      refetchGame();
    },
  });
};

export const useAddToArmyFromGarrisonMutation = () => {
  const { state: authContextState } = useAuthContext();
  const { castleService } = useAppContext();
  const { refetch: refetchGame } = useGameQuery();

  return useMutation({
    mutationFn: ({
      gameId,
      castleId,
      armyId,
      selectedGeneralIds,
    }: {
      gameId: string;
      castleId: string;
      armyId: string;
      selectedGeneralIds: string[];
    }) =>
      castleService.addToArmyFromGarrison(
        authContextState.authToken!,
        gameId,
        castleId,
        armyId,
        selectedGeneralIds
      ),
    onSuccess: () => {
      refetchGame();
    },
  });
};
