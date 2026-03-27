import browser from 'webextension-polyfill';

// You can add GitHub page-specific functionality here
async function init() {
  try {
    const authState = await browser.runtime.sendMessage({ type: 'GET_AUTH_STATE' });
    if (authState?.token) {
      // User is authenticated, you can enhance the GitHub page here
    }
  } catch (error) {
    console.error('Error initializing content script:', error);
  }
}

init();
