import browser from "webextension-polyfill";

console.log("Background script loaded");

browser.runtime.onInstalled.addListener((details) => {
  console.log("Extension installed:", details);
});

// Listen for messages from content script
browser.runtime.onMessage.addListener(async (message, sender) => {
  
});
