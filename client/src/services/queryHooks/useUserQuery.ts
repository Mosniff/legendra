import { useAuthContext } from "@/context/AuthContext";
import type { User } from "@/types/authContextTypes";
import { useQuery, type UseQueryResult } from "@tanstack/react-query";

export const useUserQuery = (): UseQueryResult<User | null, Error> => {
  const { state: authContextState, userService } = useAuthContext();
  return useQuery<User | null>({
    queryKey: ["user"],
    queryFn: () => userService.getUser(authContextState.authToken!),
    enabled: !!authContextState.authToken,
  });
};
