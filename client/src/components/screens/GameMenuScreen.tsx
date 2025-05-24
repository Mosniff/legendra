import type { Game } from "@/types/appContextTypes";

export const GameMenuScreen = ({ game }: { game: Game }) => {
  return (
    <div>
      Game Id: {game.id} Game Slot: {game.slot}
    </div>
  );
};
