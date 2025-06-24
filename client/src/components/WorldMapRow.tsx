import { WorldMapTile } from "@/components/WorldMapTile";

export const WorldMapRow = ({
  columnNumbers,
  rowNumber,
}: {
  columnNumbers: number[];
  rowNumber: number;
}) => {
  return (
    <div className="flex">
      {columnNumbers.map((columnNumber) => (
        <WorldMapTile
          key={columnNumber}
          rowNumber={rowNumber}
          columnNumber={columnNumber}
        />
      ))}
    </div>
  );
};
