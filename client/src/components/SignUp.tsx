import { useState } from "react";
import { userService } from "@/services/UserService";

export const SignUp = () => {
  const [email, setEmail] = useState<string>();
  const [password, setPassword] = useState<string>();
  const [passwordConfirm, setPasswordConfirm] = useState<string>();
  return (
    <div className="flex flex-col gap-2 flex-1">
      <h2>Sign Up:</h2>
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
        <input
          className="bg-white"
          value={password}
          onChange={(e) => {
            e.preventDefault;
            setPassword(e.target.value);
          }}
        />
      </div>
      <div className="flex justify-between">
        <span>passwordConfirm:</span>
        <input
          className="bg-white"
          value={passwordConfirm}
          onChange={(e) => {
            e.preventDefault;
            setPasswordConfirm(e.target.value);
          }}
        />
      </div>
      <button
        className="bg-red-500 border"
        disabled={
          password !== passwordConfirm ||
          !(email && password && passwordConfirm)
        }
        onClick={() => {
          if (email && password) {
            userService.signUp({ user: { email: email, password: password } });
          }
        }}
      >
        Submit
      </button>
    </div>
  );
};
