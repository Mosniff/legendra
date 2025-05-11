import { type SignInUser } from "@/types/userContextTypes";
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

export const getUser = async (authToken: string) => {
  try {
    const response = await axios.get(`${apiUrl}/current_user`, {
      headers: { Authorization: authToken },
    });
    console.log("response in getUser", response);
    return { email: response.data.email };
  } catch (err) {
    console.log("error in getUser", err);
    return null;
  }
};
