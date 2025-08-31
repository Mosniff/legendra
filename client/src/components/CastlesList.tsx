import { useCreateArmyFromGarrisonMutation } from "@/services/mutationHooks/castleMutationHooks";
import type { Castle, Game } from "@/types/gameTypes";
import { useState } from "react";

const CastleEntry = ({
  castle,
  gameId,
}: {
  castle: Castle;
  gameId: string;
}) => {
  const createArmyFromGarrisonMutation = useCreateArmyFromGarrisonMutation();
  const [formingArmy, setFormingArmy] = useState<boolean>(false);
  const [formingArmyGenerals, setFormingArmyGenerals] = useState<string[]>([]);
  return (
    <>
      <div key={castle.id}>
        {castle.name}
        {castle.isPlayerControlled && (
          <span className="text-green-500 italic"> (Player Controlled)</span>
        )}
      </div>
      {castle.garrisonedGenerals.length > 0 && (
        <>
          <ul className="ml-2">
            {castle.garrisonedGenerals.map((general) => (
              <li key={general.id}>
                {general.name}
                {formingArmy && (
                  <input
                    type="checkbox"
                    onChange={(e) => {
                      if (e.target.checked) {
                        setFormingArmyGenerals([
                          ...formingArmyGenerals,
                          general.id,
                        ]);
                      }
                      if (!e.target.checked) {
                        setFormingArmyGenerals(
                          formingArmyGenerals.filter((id) => id !== general.id)
                        );
                      }
                    }}
                  ></input>
                )}
              </li>
            ))}
          </ul>
          {castle.isPlayerControlled && (
            <div>
              {!formingArmy && (
                <button
                  className="border text-sm p-1"
                  onClick={() => setFormingArmy(true)}
                >
                  Form Army
                </button>
              )}
              {formingArmy && (
                <div>
                  <button
                    className="border text-sm p-1"
                    onClick={() => setFormingArmy(false)}
                  >
                    Cancel
                  </button>
                  <button
                    className="border text-sm p-1"
                    disabled={formingArmyGenerals.length < 1}
                    onClick={() =>
                      createArmyFromGarrisonMutation.mutate({
                        gameId: gameId,
                        castleId: castle.id,
                        selectedGeneralIds: formingArmyGenerals,
                      })
                    }
                  >
                    Accept
                  </button>
                </div>
              )}
            </div>
          )}
        </>
      )}
    </>
  );
};

export const CastlesList = ({ game }: { game: Game }) => {
  return (
    <div>
      {game.gameMap?.castles.map((castle) => (
        <CastleEntry key={castle.id} castle={castle} gameId={game.id} />
      ))}
    </div>
  );
};
