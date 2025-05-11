import "./App.css";
import { GameContainer } from "@/components/GameContainer";
import { UserContextProvider } from "@/context/UserContext";
import * as userService from "@/services/UserService";

function App() {
  return (
    <UserContextProvider userService={userService}>
      <GameContainer />
    </UserContextProvider>
  );
}

export default App;
