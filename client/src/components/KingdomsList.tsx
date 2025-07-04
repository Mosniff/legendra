import type { Game } from "@/types/gameTypes";

export const KingdomsList = ({ game }: { game: Game }) => {
  return (
    <div>
      {game.kingdoms.map((kingdom) => (
        <div>
          <div>{kingdom.name}</div>
          <div>
            <ul className="ml-2">
              {game.generals
                .filter((general) => general.kingdomId === kingdom.id)
                .map((general) => (
                  <li>{general.name}</li>
                ))}
            </ul>
          </div>
        </div>
      ))}
    </div>
  );
};
