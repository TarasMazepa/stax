import browser from 'webextension-polyfill';
import { GitHubContentService } from './services/github-content';
import { GitHubPR, HostConfig } from './types/github';

console.log('Content script loaded');

async function injectPRList() {
    const container = document.createElement('div');
    container.id = 'stax-pr-list';
    container.className = 'stax-pr-container';

    const sidebar = document.querySelector('.gh-header-show');
    if (!sidebar) return;

    sidebar.appendChild(container);

    try {
        const [owner, repo] = window.location.pathname.split('/').filter(Boolean).slice(0, 2);

        const prs = await GitHubContentService.getAllPullRequests(owner, repo, {
            state: 'open',
            sort: 'updated'
        });

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
      background-color: #22272e;
      border: 1px solid #444c56;
      border-radius: 8px;
      font-size: 13px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    }
    
    .stax-pr-header {
      padding: 12px 16px;
      font-weight: 600;
      border-bottom: 1px solid #444c56;
      background-color: #2d333b;
      border-radius: 8px 8px 0 0;
      color: #adbac7;
    }
    
    .stax-pr-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    
    .stax-pr-item {
      padding: 12px 16px;
      border-bottom: 1px solid #444c56;
      transition: background-color 0.2s ease;
    }
    
    .stax-pr-item:hover {
      background-color: #2d333b;
    }
    
    .stax-pr-item:last-child {
      border-bottom: none;
      border-radius: 0 0 8px 8px;
    }
    
    .stax-pr-link {
      color: #adbac7;
      text-decoration: none;
      display: block;
    }
    
    .stax-pr-link:hover {
      color: #539bf5;
    }
    
    .stax-pr-number {
      color: #768390;
      margin-right: 8px;
      font-weight: 500;
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

async function shouldInject(): Promise<boolean> {
    const currentHost = window.location.host;
    if (currentHost === 'github.com') {
      return true;
    }

    const { hosts } = await browser.storage.local.get(['hosts']);
    if (!hosts) return false;

    return hosts.some((h: HostConfig) => h.active && (h.domain.includes(currentHost)));
}

async function init() {
    try {
        const token = await GitHubContentService.getAuthToken();
        if (token && isPRPage()) {
            if (await shouldInject()) {
              console.log('Injecting PR list');
                injectPRList();
            }
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
            init();
        }
    }
});

observer.observe(document.body, {
    childList: true,
    subtree: true
});

init();
