import type { GameMetadata } from "@/types/authContextTypes";
import type { UseMutationResult } from "@tanstack/react-query";

type GameSelectSlabProps = {
  slotNumber: number;
  game?: GameMetadata;
  setActiveGameMutation: UseMutationResult<unknown, Error, string, unknown>;
  deleteGameMutation: UseMutationResult<unknown, Error, string, unknown>;
  createGameMutation: UseMutationResult<unknown, Error, number, unknown>;
};

const GameSelectSlab = ({
  slotNumber,
  game,
  setActiveGameMutation,
  deleteGameMutation,
  createGameMutation,
}: GameSelectSlabProps) => {
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
