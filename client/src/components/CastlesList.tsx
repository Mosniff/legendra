import { useCreateArmyFromGarrisonMutation } from "@/services/mutationHooks/castleMutationHooks";
import type { Castle, GameWorld } from "@/types/gameTypes";
import { useState } from "react";

const CastleEntry = ({
  castle,
  world,
  gameId,
}: {
  castle: Castle;
  world: GameWorld;
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
      {castle.garrisonedGeneralIds?.length > 0 && (
        <>
          <ul className="ml-2">
            {castle.garrisonedGeneralIds.map((generalId) => {
              const general = world.generals.find((g) => g.id === generalId);
              return (
                <>
                  {general && (
                    <li key={generalId}>
                      {general.name}
                      {formingArmy && (
                        <input
                          type="checkbox"
                          checked={formingArmyGenerals.includes(generalId)}
                          onChange={(e) => {
                            if (e.target.checked) {
                              setFormingArmyGenerals([
                                ...formingArmyGenerals,
                                generalId,
                              ]);
                            }
                            if (!e.target.checked) {
                              setFormingArmyGenerals(
                                formingArmyGenerals.filter(
                                  (id) => id !== generalId
                                )
                              );
                            }
                          }}
                        ></input>
                      )}
                    </li>
                  )}
                </>
              );
            })}
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
                    onClick={() => {
                      setFormingArmyGenerals([]);
                      setFormingArmy(false);
                    }}
                  >
                    Cancel
                  </button>
                  <button
                    className="border text-sm p-1"
                    disabled={formingArmyGenerals.length < 1}
                    onClick={() => {
                      createArmyFromGarrisonMutation.mutate({
                        gameId: gameId,
                        castleId: castle.id,
                        selectedGeneralIds: formingArmyGenerals,
                      });
                      setFormingArmyGenerals([]);
                    }}
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

export const CastlesList = ({ world }: { world: GameWorld }) => {
  return (
    <div>
      {world.castles.map((castle) => (
        <CastleEntry
          key={castle.id}
          world={world}
          castle={castle}
          gameId={world.gameId}
        />
      ))}
    </div>
  );
};
