import { SignIn } from "@/components/SignIn";
import { SignUp } from "@/components/SignUp";
import { GameSelectScreen } from "./screens/GameSelectScreen";
import { useAppContext } from "@/context/AppContext";
import { GameContainer } from "@/components/GameContainer";
import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import { useEffect } from "react";

export const ScreenContainer = () => {
  const { data: user, isLoading: isLoadingUser } = useUserQuery();
  const { state: appContextState } = useAppContext();

  useEffect(() => {
    console.log("user is", user);
  }, [user]);

  return (
    <div className="bg-amber-500 w-full h-full p-2">
      {isLoadingUser && <div>Loading...</div>}
      {!isLoadingUser && (
        <>
          {!user && (
            <div className="flex justify-between gap-12">
              <SignIn />
              <SignUp />
            </div>
          )}

          {user && (
            <>
              {(appContextState.currentScreen === "Game Select" ||
                appContextState.currentScreen === null) && <GameSelectScreen />}
              {appContextState.currentScreen !== "Game Select" && (
                <GameContainer />
              )}
            </>
          )}
        </>
      )}
    </div>
  );
};
