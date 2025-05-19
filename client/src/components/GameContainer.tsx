import { useUserContext } from "@/context/UserContext";
import { UserContextActionTypes } from "@/types/userContextTypes";
import { useEffect } from "react";
import { SignIn } from "@/components/SignIn";
import { SignUp } from "@/components/SignUp";
import { SignOut } from "@/components/SignOut";

export const GameContainer = () => {
  // User Context
  const { state: userContextState, dispatch, userService } = useUserContext();
  useEffect(() => {
    const storedToken = localStorage.getItem("authToken");
    if (storedToken && userContextState.authToken !== storedToken) {
      dispatch({
        type: UserContextActionTypes.SET_AUTH_TOKEN,
        payload: storedToken,
      });

      const fetchUser = async () => {
        const user = await userService.getUser(storedToken);
        dispatch({
          type: UserContextActionTypes.SET_USER,
          payload: user,
        });
      };
      fetchUser();
    }
  }, []);
  // /User Context

  const createGame = (slot: number) => {
    if (userContextState.authToken) {
      userService.createGame(userContextState.authToken, slot);
    }
  };

  return (
    <div>
      {userContextState.user && userContextState.authToken && (
        <div>
          <SignOut />
        </div>
      )}
      {(!userContextState.user || !userContextState.authToken) && (
        <div>
          <SignIn />
          <SignUp />
        </div>
      )}
      {userContextState.user && (
        <>
          <div>Signed in user: {userContextState.user?.email}</div>

          <div>Games:</div>
          {[...Array(10)].map((_, i) => {
            let game = null;
            game = userContextState.user?.games?.find((g) => g.slot === i);
            return (
              <div key={i}>
                {game ? (
                  <p>
                    Slot {i + 1}: Game {game.id}
                  </p>
                ) : (
                  <div className="flex gap-1">
                    <p>Slot {i + 1}: Empty</p>
                    <button
                      onClick={() => {
                        createGame(i);
                      }}
                    >
                      Create
                    </button>
                  </div>
                )}
              </div>
            );
          })}
        </>
      )}
    </div>
  );
};
