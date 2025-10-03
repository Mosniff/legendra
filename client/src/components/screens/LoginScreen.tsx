import { SignIn } from "@/components/SignIn";
import { SignUp } from "@/components/SignUp";

export const LoginScreen = () => {
  return (
    <div className="flex justify-between gap-12">
      <SignIn />
      <SignUp />
    </div>
  );
};
