import "./App.css";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { GameContainer } from "@/components/GameContainer";
import { AuthContextProvider } from "@/context/AuthContext";
import * as userService from "@/services/UserService";
import { AppContextProvider } from "@/context/AppContext";

const queryClient = new QueryClient();

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <AuthContextProvider userService={userService}>
        <AppContextProvider>
          <GameContainer />
        </AppContextProvider>
      </AuthContextProvider>
    </QueryClientProvider>
  );
}

export default App;
