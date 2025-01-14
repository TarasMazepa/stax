import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import webExtension from "vite-plugin-web-extension";
import { resolve } from 'path';

export default defineConfig({
  plugins: [
    react(),
    webExtension({
      manifest: () => ({
        manifest_version: 3,
        name: "Stax GitHub Extension",
        version: "1.0.0",
        permissions: [
          "identity",
          "storage",
          "identity.email"
        ],
        host_permissions: [
          "https://github.com/*",
          "https://api.github.com/*",
          "*://*.github.com/*"
        ],
        action: {
          default_popup: "src/popup.html"
        },
        background: {
          service_worker: "src/background.ts"
        },
        content_scripts: [
          {
            matches: ["https://github.com/*"],
            js: ["src/contentScript.ts"]
          }
        ]
      })
    })
  ],
  resolve: {
    alias: {
      'webextension-polyfill': resolve(__dirname, 'node_modules/webextension-polyfill')
    }
  }
});
