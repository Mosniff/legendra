import {
  useAddToArmyFromGarrisonMutation,
  useCreateArmyFromGarrisonMutation,
} from "@/services/mutationHooks/castleMutationHooks";
import type { Army, Castle, GameWorld } from "@/types/gameTypes";
import { useEffect, useState } from "react";

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
  const addToArmyFromGarrisonMutation = useAddToArmyFromGarrisonMutation();
  const [formingArmy, setFormingArmy] = useState<boolean>(false);
  const [formingArmyGenerals, setFormingArmyGenerals] = useState<string[]>([]);
  const [addingToArmy, setAddingToArmy] = useState<boolean>(false);
  const [armyToAddTo, setArmyToAddTo] = useState<Army | null>(null);

  const [addingToArmyGenerals, setAddingToArmyGenerals] = useState<string[]>(
    []
  );
  const [colocatedArmies, setColocatedArmies] = useState<Army[]>([]);
  useEffect(() => {
    const colocatedArmies = world.armies.filter(
      (army) =>
        army.xCoord == castle.xCoord &&
        army.yCoord == castle.yCoord &&
        army.isPlayerControlled
    );
    setColocatedArmies(colocatedArmies);
  }, [world]);
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
                <div key={generalId}>
                  {general && (
                    <li>
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
                      {addingToArmy && (
                        <input
                          type="checkbox"
                          checked={addingToArmyGenerals.includes(generalId)}
                          onChange={(e) => {
                            if (e.target.checked) {
                              setAddingToArmyGenerals([
                                ...addingToArmyGenerals,
                                generalId,
                              ]);
                            }
                            if (!e.target.checked) {
                              setAddingToArmyGenerals(
                                addingToArmyGenerals.filter(
                                  (id) => id !== generalId
                                )
                              );
                            }
                          }}
                        ></input>
                      )}
                    </li>
                  )}
                </div>
              );
            })}
          </ul>
          {castle.isPlayerControlled && (
            <>
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
              <div>
                {!addingToArmy && (
                  <button
                    className="border text-sm p-1"
                    onClick={() => setAddingToArmy(true)}
                  >
                    Add To Army
                  </button>
                )}
                {addingToArmy && (
                  <>
                    <button
                      className="border text-sm p-1"
                      onClick={() => {
                        setAddingToArmyGenerals([]);
                        setArmyToAddTo(null);
                        setAddingToArmy(false);
                      }}
                    >
                      Cancel
                    </button>
                    <button
                      className="border text-sm p-1"
                      disabled={addingToArmyGenerals.length < 1 || !armyToAddTo}
                      onClick={() => {
                        if (!armyToAddTo) return;
                        addToArmyFromGarrisonMutation.mutate({
                          gameId: gameId,
                          castleId: castle.id,
                          armyId: armyToAddTo.id,
                          selectedGeneralIds: addingToArmyGenerals,
                        });
                        setAddingToArmyGenerals([]);
                      }}
                    >
                      Accept
                    </button>
                  </>
                )}
              </div>
              {addingToArmy && (
                <div>
                  Co-located Armes:
                  {colocatedArmies.map((army) => (
                    <div key={army.id}>
                      <div className="flex">
                        <span>Army id: {army.id}</span>
                        <input
                          type="checkbox"
                          checked={armyToAddTo?.id == army.id}
                          onChange={(e) => {
                            if (e.target.checked) {
                              setArmyToAddTo(army);
                            }
                            if (!e.target.checked) {
                              setArmyToAddTo(null);
                            }
                          }}
                        ></input>
                      </div>
                      {army.generalIds.map((generalId) => {
                        const general = world.generals.find(
                          (g) => g.id === generalId
                        );
                        return <div>{general?.name}</div>;
                      })}
                    </div>
                  ))}
                </div>
              )}
            </>
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
