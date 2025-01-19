import browser from 'webextension-polyfill';
import { GitHubContentService } from './services/github-content';
import { GitHubPR } from './types/github';

console.log('Content script loaded');

async function injectPRList() {
  const container = document.createElement('div');
  container.id = 'stax-pr-list';
  container.className = 'stax-pr-container';  
  
  const sidebar = document.querySelector('.Layout-sidebar');
  if (!sidebar) return;
  
  sidebar.insertBefore(container, sidebar.firstChild);
  
  try {
    const [owner, repo] = window.location.pathname.split('/').filter(Boolean).slice(0, 2);
    
    const prs = await GitHubContentService.getAllPullRequests(owner, repo, {
      state: 'open',
      sort: 'updated'
    });

    console.log('prs', prs);
    
    renderPRList(container, prs);
  } catch (error) {
    console.error('Failed to load PRs:', error);
    container.innerHTML = `
      <div class="flash flash-error">
        Failed to load pull requests. Please ensure you're logged in.
      </div>
    `;
  }
}

function renderPRList(container: HTMLElement, prs: GitHubPR[]) {
  const style = document.createElement('style');
  style.textContent = `
    .stax-pr-container {
      margin-bottom: 16px;
      background-color: #1b1b4d;
      border: 1px solid red;
      border-radius: 6px;
      font-size: 12px;
    }
    
    .stax-pr-header {
      padding: 8px 16px;
      font-weight: 600;
      border-bottom: 1px solid var(--color-border-default);
      background-color: var(--color-canvas-subtle);
    }
    
    .stax-pr-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    
    .stax-pr-item {
      padding: 8px 16px;
      border-bottom: 1px solid var(--color-border-muted);
    }
    
    .stax-pr-item:last-child {
      border-bottom: none;
    }
    
    .stax-pr-link {
      color: var(--color-fg-default);
      text-decoration: none;
    }
    
    .stax-pr-link:hover {
      color: var(--color-accent-fg);
    }
    
    .stax-pr-number {
      color: var(--color-fg-muted);
    }
  `;
  document.head.appendChild(style);
  
  container.innerHTML = `
    <div class="stax-pr-header">
      Your Pull Requests
    </div>
    <ul class="stax-pr-list">
      ${prs.map(pr => `
        <li class="stax-pr-item">
          <a href="${pr.html_url}" class="stax-pr-link">
            <span class="stax-pr-number">#${pr.number}</span>
            ${pr.title}
          </a>
        </li>
      `).join('')}
    </ul>
  `;
}

function isPRPage() {
  const path = window.location.pathname;
  return /^\/[^/]+\/[^/]+\/pull\/\d+/.test(path);
}


async function init() {
  try {
    const authState = await browser.runtime.sendMessage({ type: 'GET_AUTH_STATE' });
    if (authState?.token && isPRPage()) {
      injectPRList();
    }
  } catch (error) {
    console.error('Error initializing content script:', error);
  }
}


let currentPath = window.location.pathname;
const observer = new MutationObserver(() => {
  if (currentPath !== window.location.pathname) {
    currentPath = window.location.pathname;
    if (isPRPage()) {
      injectPRList();
    }
  }
});

observer.observe(document.body, {
  childList: true,
  subtree: true
});

init();
