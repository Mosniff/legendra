import "../src/App.css";
import type { Preview } from "@storybook/react-vite";
import { AuthContextProvider } from "../src/context/AuthContext";
import { userService } from "../src/services/UserService";
import { AppContextProvider } from "../src/context/AppContext";
import { gameService } from "../src/services/GameService";
import { castleService } from "../src/services/CastleService";
import { armyService } from "../src/services/ArmyService";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient();

const preview: Preview = {
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },

    a11y: {
      // 'todo' - show a11y violations in the test UI only
      // 'error' - fail CI on a11y violations
      // 'off' - skip a11y checks entirely
      test: "todo",
    },
  },
  decorators: [
    (Story) => (
      <QueryClientProvider client={queryClient}>
        <AuthContextProvider userService={userService}>
          <AppContextProvider
            gameService={gameService}
            castleService={castleService}
            armyService={armyService}
          >
            <Story />
          </AppContextProvider>
        </AuthContextProvider>
      </QueryClientProvider>
    ),
  ],
};

export default preview;
