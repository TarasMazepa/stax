import browser from 'webextension-polyfill';
import { AuthState, GitHubUser, GitHubPR } from '../types/github';

const CLIENT_ID = import.meta.env.VITE_GITHUB_CLIENT_ID;
const CLIENT_SECRET = import.meta.env.VITE_GITHUB_CLIENT_SECRET;
const REDIRECT_URL = browser.identity.getRedirectURL();

export class GitHubService {
    private static async getAuthState(): Promise<AuthState> {
        const result = await browser.storage.local.get(['authState']);
        return result.authState || { token: null, user: null, customDomain: 'github.com' };
    }

    private static async setAuthState(state: AuthState): Promise<void> {
        await browser.storage.local.set({ authState: state });
    }

    static async login(): Promise<AuthState> {
        const state = Math.random().toString(36).substring(7);
        const authUrl = new URL('https://github.com/login/oauth/authorize');

        authUrl.searchParams.append('client_id', CLIENT_ID);
        authUrl.searchParams.append('redirect_uri', REDIRECT_URL);
        authUrl.searchParams.append('state', state);
        authUrl.searchParams.append('scope', 'repo user');
        authUrl.searchParams.append('response_type', 'code');

        try {
            const responseUrl = await browser.identity.launchWebAuthFlow({
                url: authUrl.toString(),
                interactive: true
            });

            const url = new URL(responseUrl);
            const code = url.searchParams.get('code');
            const returnedState = url.searchParams.get('state');

            if (!code) {
                throw new Error('No authorization code received');
            }

            if (state !== returnedState) {
                throw new Error('State mismatch - possible CSRF attack');
            }

            const token = await this.getAccessToken(code);
            const user = await this.getCurrentUser(token);

            const authState = { token, user, customDomain: 'github.com' };
            await this.setAuthState(authState);
            return authState;

        } catch (error) {
            console.error('Login failed:', error);
            if (error instanceof Error) {
                throw new Error(`GitHub authentication failed: ${error.message}`);
            }
            throw error;
        }
    }

    static async logout(): Promise<void> {
        await this.setAuthState({ token: null, user: null, customDomain: 'github.com' });
    }

    static async getCurrentUser(token: string): Promise<GitHubUser> {
        const response = await fetch('https://api.github.com/user', {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        return response.json();
    }

    static async getPullRequests(owner: string, repo: string, options: {
        state?: 'open' | 'closed' | 'all';
        sort?: 'created' | 'updated' | 'popularity' | 'long-running';
        direction?: 'asc' | 'desc';
        per_page?: number;
        page?: number;
    } = {}): Promise<GitHubPR[]> {
        const authState = await this.getAuthState();
        if (!authState.token) throw new Error('Not authenticated');

        const params = new URLSearchParams({
            state: options.state || 'open',
            sort: options.sort || 'created',
            direction: options.direction || 'desc',
            per_page: options.per_page?.toString() || '30',
            page: options.page?.toString() || '1'
        });

        const response = await fetch(
            `https://api.github.com/repos/${owner}/${repo}/pulls?${params}`,
            {
                headers: {
                    Authorization: `Bearer ${authState.token}`,
                    Accept: 'application/vnd.github.v3+json',
                },
            }
        );

        if (!response.ok) {
            throw new Error(`Failed to fetch pull requests: ${response.statusText}`);
        }

        return response.json();
    }

    static async getAllPullRequests(owner: string, repo: string, options: {
        state?: 'open' | 'closed' | 'all';
        sort?: 'created' | 'updated' | 'popularity' | 'long-running';
        direction?: 'asc' | 'desc';
    } = {}): Promise<GitHubPR[]> {
        const allPRs: GitHubPR[] = [];
        let page = 1;
        const PER_PAGE = 100; // Maximum allowed by GitHub API

        while (true) {
            const prs = await this.getPullRequests(owner, repo, {
                ...options,
                per_page: PER_PAGE,
                page: page
            });

            if (prs.length === 0) break;

            allPRs.push(...prs);

            if (prs.length < PER_PAGE) break;
            page++;
        }

        return allPRs;
    }

    private static async getAccessToken(code: string): Promise<string> {
        const response = await fetch('https://github.com/login/oauth/access_token', {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                client_id: CLIENT_ID,
                client_secret: CLIENT_SECRET,
                code,
                redirect_uri: REDIRECT_URL,
            }),
        });

        if (!response.ok) {
            throw new Error('Failed to exchange code for token');
        }

        const data = await response.json();
        return data.access_token;
    }

    static async getCurrentUserPRs(owner: string, repo: string): Promise<GitHubPR[]> {
        const authState = await this.getAuthState();
        if (!authState.token || !authState.user) {
            throw new Error('Not authenticated');
        }

        return this.getAllPullRequests(owner, repo, {
            state: 'open',
            sort: 'updated',
        });
    }
}
