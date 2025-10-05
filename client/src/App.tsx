import "./App.css";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { AppContainer } from "@/components/containers/AppContainer";
import { AuthContextProvider } from "@/context/AuthContext";
import { userService } from "@/services/UserService";
import { AppContextProvider } from "@/context/AppContext";
import { gameService } from "@/services/GameService";
import { castleService } from "@/services/CastleService";
import { armyService } from "@/services/ArmyService";

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
