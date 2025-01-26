import browser from "webextension-polyfill";


browser.runtime.onInstalled.addListener((details) => {
    console.log("Extension installed:", details);
});

// Listen for messages from content script
browser.runtime.onMessage.addListener(async (message, sender) => {
    if (message.type === 'GET_AUTH_STATE') {
        const state = await browser.storage.local.get(['authState']);
        return state.authState;
    }
});
