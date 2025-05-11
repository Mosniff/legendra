import { useState } from "react";
import { signUp } from "@/services/UserService";

export const SignUp = () => {
  const [email, setEmail] = useState<string>();
  const [password, setPassword] = useState<string>();
  const [passwordConfirm, setPasswordConfirm] = useState<string>();
  return (
    <div>
      SignupForm
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
      passwordConfirm:{" "}
      <input
        value={passwordConfirm}
        onChange={(e) => {
          e.preventDefault;
          setPasswordConfirm(e.target.value);
        }}
      />
      <button
        disabled={
          password !== passwordConfirm ||
          !(email && password && passwordConfirm)
        }
        onClick={() => {
          if (email && password) {
            signUp({ user: { email: email, password: password } });
          }
        }}
      >
        Submit
      </button>
    </div>
  );
};
