import { useAddToGarrisonFromArmyMutation } from "@/services/mutationHooks/armyMutationHooks";
import type { Army, GameWorld } from "@/types/gameTypes";
import { useState } from "react";

const ArmyEntry = ({
  army,
  world,
  gameId,
}: {
  army: Army;
  world: GameWorld;
  gameId: string;
}) => {
  const addToGarrisonFromArmyMutation = useAddToGarrisonFromArmyMutation();
  const [castleMenuOpen, setCastleMenuOpen] = useState<boolean>(false);
  const [enteringCastleGenerals, setEnteringCastleGenerals] = useState<
    string[]
  >([]);
  return (
    <div>
      Army at ({army.xCoord},{army.yCoord}), Kingdom {army.kingdomId}:
      {army.generalIds.map((generalId) => {
        const general = world.generals.find((g) => g.id === generalId);
        return (
          general && (
            <div key={general.id}>
              {general.name}
              {castleMenuOpen && (
                <input
                  type="checkbox"
                  onChange={(e) => {
                    if (e.target.checked) {
                      setEnteringCastleGenerals([
                        ...enteringCastleGenerals,
                        generalId,
                      ]);
                    }
                    if (!e.target.checked) {
                      setEnteringCastleGenerals(
                        enteringCastleGenerals.filter((id) => id !== generalId)
                      );
                    }
                  }}
                ></input>
              )}
            </div>
          )
        );
      })}
      {army.isPlayerControlled && (
        <>
          {!castleMenuOpen && (
            <button
              className="border text-sm p-1"
              onClick={() => setCastleMenuOpen(true)}
            >
              Castle Menu
            </button>
          )}
          {castleMenuOpen && (
            <div>
              <button
                className="border text-sm p-1"
                onClick={() => setCastleMenuOpen(false)}
              >
                Cancel
              </button>
              <button
                className="border text-sm p-1"
                disabled={enteringCastleGenerals.length < 1}
                onClick={() =>
                  addToGarrisonFromArmyMutation.mutate({
                    gameId: gameId,
                    armyId: army.id,
                    selectedGeneralIds: enteringCastleGenerals,
                  })
                }
              >
                Accept
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
};

export const ArmiesList = ({ world }: { world: GameWorld }) => {
  return (
    <div>
      {world.armies.map((army) => (
        <div key={army.id}>
          <ArmyEntry army={army} world={world} gameId={world.gameId} />
        </div>
      ))}
    </div>
  );
};
