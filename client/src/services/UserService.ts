import { type SignInUser, type User } from "@/types/authContextTypes";
import axios from "axios";

const apiUrl = import.meta.env.VITE_API_URL;

export const signUp = async (userObject: SignInUser) => {
  try {
    return await axios.post(`${apiUrl}/signup`, userObject);
  } catch (err) {
    console.log("error in signUp", err);
    return null;
  }
};

export const signIn = async (userObject: SignInUser) => {
  try {
    return await axios.post(`${apiUrl}/login`, userObject);
  } catch (err) {
    console.log("error in signIn", err);
    return null;
  }
};

export const signOut = async (authToken: string) => {
  try {
    return await axios.delete(`${apiUrl}/logout`, {
      headers: { Authorization: authToken },
    });
  } catch (err) {
    console.log("error in signOut", err);
    return null;
  }
};

export const getUser = async (authToken: string): Promise<User | null> => {
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
};

export const createGameForUser = async (authToken: string, slot: number) => {
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
};

export const setActiveGameForUser = async (authToken: string, id: string) => {
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
};

// export const deleteGame = async (authToken: string, gameId: string) => {
