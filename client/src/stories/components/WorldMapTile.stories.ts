import type { Meta, StoryObj } from "@storybook/react-vite";
import { WorldMapTile } from "@/components/WorldMapTile";
import { dummyMapTile } from "@/tests/dummyData/gameMap";

const meta = {
  title: "Components/WorldMap/Tile",
  component: WorldMapTile,
  parameters: {
    layout: "centered",
  },
  argTypes: {
    terrain: {
      options: ["grassland", "desert", "snow"],
      control: { type: "select" },
    },
  },
} satisfies Meta<typeof WorldMapTile>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: dummyMapTile(),
};

export const WithCastle: Story = {
  args: dummyMapTile({ withCastle: true }),
};

export const WithTown: Story = {
  args: dummyMapTile({ withTown: true }),
};
