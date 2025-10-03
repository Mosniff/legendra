import type { Meta, StoryObj } from "@storybook/react-vite";
import { WorldMapScreen } from "./WorldMapScreen";
import { ScreenContainer } from "@/components/containers/ScreenContainer";

const meta = {
  title: "Screens/WorldMap",
  component: WorldMapScreen,
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
} satisfies Meta<typeof WorldMapScreen>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};
