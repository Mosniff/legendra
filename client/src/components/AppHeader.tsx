import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import { SignOut } from "@/components/SignOut";

export const AppHeader = () => {
  const { data: user, isLoading: isLoadingUser } = useUserQuery();
  return (
    <div className="bg-red-500 w-full h-12">
      {!isLoadingUser && user && (
        <div className="flex items-center justify-between px-4 h-full">
          <div>Signed in user: {user?.email}</div>
          <SignOut />
        </div>
      )}
    </div>
  );
};
