import { useUserQuery } from "@/services/queryHooks/useUserQuery";
import GameSelectSlab from "@/components/GameSelectSlab";

export const GameSelectScreen = () => {
  const { data: user, isLoading } = useUserQuery();

  return (
    <div className="flex flex-col gap-2 h-full">
      <div>Games:</div>
      {isLoading && <div>Loading...</div>}
      {!isLoading && user && (
        <div className="flex flex-col gap-2 overflow-y-scroll flex-1">
          {[...Array(10)].map((_, i) => {
            let game = null;
            game = user?.gamesMetadata.find((g) => g.slot === i);
            return (
              <div key={i}>
                <GameSelectSlab slotNumber={i} game={game} />
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};
