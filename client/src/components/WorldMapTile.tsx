import type { MapTile } from "@/types/gameTypes";

const LandmarkIcon = ({ name, type }: { name: string; type: string }) => {
  const landmarkColors: { [key: string]: string } = {
    castle: "bg-gray-600",
    town: "bg-amber-700",
  };

  return (
    <div
      className={`h-12 w-12 ${landmarkColors[type]}`}
      title={`${name} ${type}`}
    />
  );
};

const RouteIcon = () => {
  return <div className="h-8 w-8 bg-yellow-300" />;
};

export const WorldMapTile = ({
  terrain,
  xCoord,
  yCoord,
  routeTile,
  castle,
  town,
}: MapTile) => {
  const terrainColors: { [key: string]: string } = {
    desert: "bg-yellow-200",
    grassland: "bg-green-500",
    snow: "bg-gray-100",
  };

  let landmark = null;

  if (castle) {
    landmark = { ...castle, type: "castle" };
  } else if (town) {
    landmark = { ...town, type: "town" };
  }

  return (
    <div
      className={`h-24 w-24 border flex justify-center items-center relative ${terrainColors[terrain]}`}
      title={`Tile at X:${xCoord}, Y:${yCoord}`}
    >
      {landmark && <LandmarkIcon name={landmark.name} type={landmark.type} />}
      {!landmark && routeTile && <RouteIcon />}
    </div>
  );
};
