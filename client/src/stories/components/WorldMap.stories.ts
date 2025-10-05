import type { Meta, StoryObj } from "@storybook/react-vite";
import { WorldMap } from "@/components/WorldMap";
import { dummyGameMapSmall } from "@/tests/dummyData/gameMap";

const meta = {
  title: "Components/WorldMap/Map",
  component: WorldMap,
  parameters: {
    layout: "centered",
  },
} satisfies Meta<typeof WorldMap>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: dummyGameMapSmall,
};
