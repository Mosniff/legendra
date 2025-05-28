import { useAuthContext } from "@/context/AuthContext";
import { AuthContextActionTypes } from "@/types/authContextTypes";
import { useState } from "react";
import { useQueryClient } from "@tanstack/react-query";

export const SignIn = () => {
  const { dispatch, userService } = useAuthContext();
  const [email, setEmail] = useState<string>();
  const [password, setPassword] = useState<string>();
  const queryClient = useQueryClient();

  return (
    <div className="flex flex-col gap-2 flex-1">
      <h2>Sign In:</h2>
      <div className="flex justify-between">
        <span>email:</span>
        <div>
          <input
            className="bg-white"
            value={email}
            onChange={(e) => {
              e.preventDefault;
              setEmail(e.target.value);
            }}
          />
        </div>
      </div>
      <div className="flex justify-between">
        <span>password:</span>
        <div>
          <input
            className="bg-white"
            value={password}
            onChange={(e) => {
              e.preventDefault;
              setPassword(e.target.value);
            }}
          />
        </div>
      </div>
      <button
        className="bg-red-500 border"
        disabled={!(email && password)}
        onClick={async () => {
          if (email && password) {
            const signInResponse = await userService.signIn({
              user: { email: email, password: password },
            });
            if (signInResponse) {
              dispatch({
                type: AuthContextActionTypes.SET_AUTH_TOKEN,
                payload: signInResponse.headers.authorization,
              });
              localStorage.setItem(
                "authToken",
                signInResponse.headers.authorization
              );
              queryClient.invalidateQueries({ queryKey: ["user"] });
            }
          }
        }}
      >
        Login
      </button>
      <button
        className="bg-red-500 border"
        onClick={async () => {
          const signInResponse = await userService.signIn({
            user: { email: "test@test.com", password: "123456" },
          });
          if (signInResponse) {
            dispatch({
              type: AuthContextActionTypes.SET_AUTH_TOKEN,
              payload: signInResponse.headers.authorization,
            });
            localStorage.setItem(
              "authToken",
              signInResponse.headers.authorization
            );
            queryClient.invalidateQueries({ queryKey: ["user"] });
          }
        }}
      >
        Debug Login
      </button>
    </div>
  );
};
