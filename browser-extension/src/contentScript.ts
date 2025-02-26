import browser from 'webextension-polyfill';
import { GitHubService } from './services/github';

console.log('Content script loaded');

function isPRPage() {
  const path = window.location.pathname;
  return /^\/[^/]+\/[^/]+\/pull\/\d+/.test(path);
}

async function fetchPrList(){
  const [owner, repo] = window.location.pathname.split('/').filter(Boolean).slice(0, 2);
  const authState = await browser.runtime.sendMessage({type: 'GET_AUTH_STATE'});

  if (!authState?.user?.login) {
    throw new Error('User not authenticated');
  }

  const prs = await GitHubService.getAllPullRequests(owner, repo);

  // TODO: Next PR Render the PR list instade of console log
  console.log(prs);
}

async function init() {
  try {
    const authState = await browser.runtime.sendMessage({ type: 'GET_AUTH_STATE' });
    if (authState?.token && isPRPage()) {
      fetchPrList();
    }
  } catch (error) {
    console.error('Error initializing content script:', error);
  }
}

init();
