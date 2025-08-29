import type { Game } from "@/types/gameTypes";

export const KingdomsList = ({ game }: { game: Game }) => {
  return (
    <div>
      {game.kingdoms.map((kingdom) => (
        <div key={kingdom.id}>
          <div>{kingdom.name}</div>
          <div>
            <ul className="ml-2">
              {game.generals
                .filter((general) => general.kingdomId === kingdom.id)
                .map((general) => (
                  <li key={general.id}>{general.name}</li>
                ))}
            </ul>
          </div>
        </div>
      ))}
      <div>Indepedent Generals</div>
      <div>
        <ul className="ml-2">
          {game.generals
            .filter((general) => !general.kingdomId)
            .map((general) => (
              <li key={general.id}>{general.name}</li>
            ))}
        </ul>
      </div>
    </div>
  );
};
