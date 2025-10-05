import { type SignInUser, type User } from "@/types/authContextTypes";
import type { UserService } from "@/types/serviceTypes";
import axios from "axios";

const apiUrl = import.meta.env.VITE_API_URL;

export const userService: UserService = {
  signUp: async (userObject: SignInUser) => {
    try {
      return await axios.post(`${apiUrl}/signup`, userObject);
    } catch (err) {
      console.log("error in signUp", err);
      return null;
    }
  },

  signIn: async (userObject: SignInUser) => {
    try {
      return await axios.post(`${apiUrl}/login`, userObject);
    } catch (err) {
      console.log("error in signIn", err);
      return null;
    }
  },

  signOut: async (authToken: string) => {
    try {
      return await axios.delete(`${apiUrl}/logout`, {
        headers: { Authorization: authToken },
      });
    } catch (err) {
      console.log("error in signOut", err);
      return null;
    }
  },

  getUser: async (authToken: string): Promise<User | null> => {
    try {
      const response = await axios.get(`${apiUrl}/current_user`, {
        headers: { Authorization: authToken },
      });
      console.log("response in getUser", response);
      return {
        email: response.data.user.email,
        gamesMetadata: response.data.games,
        activeGameId: response.data.active_game_id,
      };
    } catch (err) {
      console.log("error in getUser", err);
      return null;
    }
  },

  createGameForUser: async (authToken: string, slot: number) => {
    try {
      const response = await axios.post(
        `${apiUrl}/games`,
        { slot },
        {
          headers: { Authorization: authToken },
        }
      );
      return response.data;
    } catch (err) {
      console.log("error in createGame", err);
      return null;
    }
  },

  setActiveGameForUser: async (authToken: string, id: string) => {
    try {
      const response = await axios.patch(
        `${apiUrl}/games/${id}`,
        { active: true },
        {
          headers: { Authorization: authToken },
        }
      );
      return response.data;
    } catch (err) {
      console.log("error in setActiveGame", err);
      return null;
    }
  },

  deleteGameForUser: async (authToken: string, id: string) => {
    try {
      const response = await axios.delete(`${apiUrl}/games/${id}`, {
        headers: { Authorization: authToken },
      });
      return response.data;
    } catch (err) {
      console.log("error in deleteGame", err);
      return null;
    }
  },
};
