import "./App.css";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { AppContainer } from "@/components/containers/AppContainer";
import { AuthContextProvider } from "@/context/AuthContext";
import * as userService from "@/services/UserService";
import { AppContextProvider } from "@/context/AppContext";
import * as gameService from "@/services/GameService";
import * as castleService from "@/services/CastleService";
import * as armyService from "@/services/ArmyService";

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthContextProvider userService={userService}>
        <AppContextProvider
          gameService={gameService}
          castleService={castleService}
          armyService={armyService}
        >
          <AppContainer />
        </AppContextProvider>
      </AuthContextProvider>
    </QueryClientProvider>
  );
}

export default App;
