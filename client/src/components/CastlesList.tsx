import type { GameMap } from "@/types/gameTypes";

export const CastlesList = ({ gameMap }: { gameMap: GameMap }) => {
  return (
    <div>
      {gameMap.castles.map((castle) => (
        <>
          <div key={castle.id}>{castle.name}</div>
          {castle.garrisonedGenerals.length > 0 && (
            <ul className="ml-2">
              {castle.garrisonedGenerals.map((general) => (
                <li key={general.id}>{general.name}</li>
              ))}
            </ul>
          )}
          {castle.garrisonedGenerals.length == 0 && (
            <div className="ml-2 italic">Empty</div>
          )}
        </>
      ))}
    </div>
  );
};
