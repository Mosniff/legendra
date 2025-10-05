import type { Meta, StoryObj } from "@storybook/react-vite";
import { WorldMapRow } from "@/components/WorldMapRow";
import { dummyMapTile } from "@/tests/dummyData/gameMap";

const meta = {
  title: "Components/WorldMap/Row",
  component: WorldMapRow,
  parameters: {
    layout: "centered",
  },
} satisfies Meta<typeof WorldMapRow>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    tiles: [
      dummyMapTile(),
      dummyMapTile(),
      dummyMapTile(),
      dummyMapTile(),
      dummyMapTile(),
    ],
  },
};
