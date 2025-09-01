import type { GameWorld } from "@/types/gameTypes";

export const ArmiesList = ({ world }: { world: GameWorld }) => {
  return (
    <div>
      {world.armies.map((army) => (
        <div key={army.id}>
          Army at ({army.xCoord},{army.yCoord}), Kingdom {army.kingdomId}:
          {army.generalIds.map((generalId) => {
            const general = world.generals.find((g) => g.id === generalId);
            return general && <div key={general.id}>{general.name}</div>;
          })}
        </div>
      ))}
    </div>
  );
};
