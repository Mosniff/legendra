import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";
import tailwindcss from "@tailwindcss/vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: {
    alias: {
      "@/components": path.resolve(__dirname, "src/components"),
      "@/context": path.resolve(__dirname, "src/context"),
      "@/types": path.resolve(__dirname, "src/types"),
      "@/reducers": path.resolve(__dirname, "src/context/reducers"),
      "@/services": path.resolve(__dirname, "src/services"),
    },
  },
  server: {
    port: 3000,
  },
});
