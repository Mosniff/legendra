import type { StorybookConfig } from "@storybook/react-vite";
import { mergeConfig } from "vite";
import { resolve } from "path";

const config: StorybookConfig = {
  stories: ["../src/**/*.mdx", "../src/**/*.stories.@(js|jsx|mjs|ts|tsx)"],
  addons: [
    "@chromatic-com/storybook",
    "@storybook/addon-docs",
    "@storybook/addon-onboarding",
    "@storybook/addon-a11y",
    "@storybook/addon-vitest",
  ],
  framework: {
    name: "@storybook/react-vite",
    options: {},
  },
  viteFinal: async (config) => {
    return mergeConfig(config, {
      resolve: {
        alias: {
          "@/components": resolve(__dirname, "../src/components"),
          "@/context": resolve(__dirname, "../src/context"),
          "@/types": resolve(__dirname, "../src/types"),
          "@/reducers": resolve(__dirname, "../src/context/reducers"),
          "@/services": resolve(__dirname, "../src/services"),
          "@/tests": resolve(__dirname, "../src/tests"),
        },
      },
    });
  },
};
export default config;
