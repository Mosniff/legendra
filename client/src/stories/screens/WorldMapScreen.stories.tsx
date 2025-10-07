import type { Meta, StoryObj } from "@storybook/react-vite";
import { WorldMapScreenPresentation } from "./WorldMapScreen";
import { ScreenContainer } from "@/components/containers/ScreenContainer";
import { dummyGame } from "@/tests/dummyData/game";

const meta = {
  title: "Screens/WorldMap",
  component: WorldMapScreenPresentation,
  parameters: {
    layout: "fullscreen",
  },
  decorators: [
    (Story) => (
      <div className="h-screen w-full flex flex-col items-center">
        <ScreenContainer>
          <Story />
        </ScreenContainer>
      </div>
    ),
  ],
} satisfies Meta<typeof WorldMapScreenPresentation>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: { game: dummyGame(), isLoadingGame: false },
};
