import browser from 'webextension-polyfill';

console.log('Content script loaded');

// You can add GitHub page-specific functionality here
async function init() {
  try {
    const authState = await browser.runtime.sendMessage({ type: 'GET_AUTH_STATE' });
    if (authState?.token) {
      // User is authenticated, you can enhance the GitHub page here
      console.log('User is authenticated');
    }
  } catch (error) {
    console.error('Error initializing content script:', error);
  }
}

init(); 