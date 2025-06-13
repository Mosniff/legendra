import {
  useCreateGameMutation,
  useDeleteGameMutation,
  useSetActiveGameMutation,
} from "@/services/mutationHooks/gameMutationHooks";
import type { GameMetadata } from "@/types/authContextTypes";

type GameSelectSlabProps = {
  slotNumber: number;
  game?: GameMetadata;
};

const GameSelectSlab = ({ slotNumber, game }: GameSelectSlabProps) => {
  const createGameMutation = useCreateGameMutation();
  const setActiveGameMutation = useSetActiveGameMutation();
  const deleteGameMutation = useDeleteGameMutation();

  return (
    <div className="border flex justify-between p-2">
      <div className="flex gap-1 items-center">
        <span>Slot {slotNumber + 1}:</span>
        {game && (
          <>
            <span>Game {game.id}</span>
            <div className="text-sm italic text-blue-500">
              {game.active ? "(Active)" : "(Inactive)"}
            </div>
          </>
        )}
        {!game && <span>Empty</span>}
      </div>
      <div className="flex gap-2">
        {game && (
          <>
            <button
              className="bg-black text-white p-1"
              onClick={() => {
                setActiveGameMutation.mutate(game.id);
              }}
            >
              Goto
            </button>
            <button
              className="bg-black text-white p-1"
              onClick={() => {
                deleteGameMutation.mutate(game.id);
              }}
            >
              Delete
            </button>
          </>
        )}
        {!game && (
          <button
            className="bg-black text-white p-1"
            onClick={() => {
              createGameMutation.mutate(slotNumber);
            }}
            disabled={createGameMutation.isPending}
          >
            {createGameMutation.isPending ? "Creating..." : "Create"}
          </button>
        )}
      </div>
    </div>
  );
};

export default GameSelectSlab;
