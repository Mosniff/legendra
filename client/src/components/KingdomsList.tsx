import type { GameWorld } from "@/types/gameTypes";

export const KingdomsList = ({ world }: { world: GameWorld }) => {
  return (
    <div>
      {world.kingdoms.map((kingdom) => (
        <div key={kingdom.id}>
          <div>{kingdom.name}</div>
          <div>
            <ul className="ml-2">
              {world.generals
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
          {world.generals
            .filter((general) => !general.kingdomId)
            .map((general) => (
              <li key={general.id}>{general.name}</li>
            ))}
        </ul>
      </div>
    </div>
  );
};
