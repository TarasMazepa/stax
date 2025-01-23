import browser from "webextension-polyfill";
import { HostConfig } from "./types/github";

browser.runtime.onInstalled.addListener((details) => {
  console.log("Extension installed:", details);
});

// Listen for messages from content script
browser.runtime.onMessage.addListener(async (message) => {
  if (message.type === 'GET_TOKEN') {
    const { hosts } = await browser.storage.local.get(['hosts']);
    
    if (hosts) {
      const activeHost = hosts.find((h: HostConfig) => h.active);
      if (activeHost?.pat) {
        return activeHost.pat;
      }
    }

    const { authState } = await browser.storage.local.get(['authState']);
    return authState?.token || null;
  }
});
