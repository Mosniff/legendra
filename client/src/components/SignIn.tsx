import { useUserContext } from "@/context/UserContext";
import { UserContextActionTypes } from "@/types/userContextTypes";
import { useState } from "react";

export const SignIn = () => {
  const { dispatch, userService } = useUserContext();
  const [email, setEmail] = useState<string>();
  const [password, setPassword] = useState<string>();
  return (
    <div>
      Sign In:
      <br />
      email:{" "}
      <input
        value={email}
        onChange={(e) => {
          e.preventDefault;
          setEmail(e.target.value);
        }}
      />
      password:{" "}
      <input
        value={password}
        onChange={(e) => {
          e.preventDefault;
          setPassword(e.target.value);
        }}
      />
      <button
        disabled={!(email && password)}
        onClick={async () => {
          if (email && password) {
            const signInResponse = await userService.signIn({
              user: { email: email, password: password },
            });
            if (signInResponse) {
              console.log(signInResponse);
              const userObject = {
                email: signInResponse.data.status.user.email,
              };
              dispatch({
                type: UserContextActionTypes.SET_USER,
                payload: userObject,
              });
              dispatch({
                type: UserContextActionTypes.SET_AUTH_TOKEN,
                payload: signInResponse.headers.authorization,
              });
              localStorage.setItem(
                "authToken",
                signInResponse.headers.authorization
              );
            }
          }
        }}
      >
        Login
      </button>
    </div>
  );
};
