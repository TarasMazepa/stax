import browser from 'webextension-polyfill';
import { AuthState, GitHubUser, GitHubPR, HostConfig } from '../types/github';

const CLIENT_ID = import.meta.env.VITE_GITHUB_CLIENT_ID;
const CLIENT_SECRET = import.meta.env.VITE_GITHUB_CLIENT_SECRET;

export class GitHubService {
    private static async getAuthState(): Promise<AuthState> {
        const result = await browser.storage.local.get(['authState']);
        return result.authState || { token: null, user: null, customDomain: 'github.com' };
    }

    private static async setAuthState(state: AuthState): Promise<void> {
        await browser.storage.local.set({ authState: state });
    }

    static async login(): Promise<AuthState> {
        const domain = await this.getDomain();
        const state = Math.random().toString(36).substring(7);
        console.log('domain', domain);
        const authUrl = new URL(`${domain}/login/oauth/authorize`);

        authUrl.searchParams.append('client_id', CLIENT_ID);
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

    private static async getActiveHost(): Promise<HostConfig | null> {
        const { hosts } = await browser.storage.local.get(['hosts']);
        if (!hosts) return null;

        return hosts.find((h: HostConfig) => h.active) || null;
    }

    private static async getApiUrl(): Promise<string> {
        const host = await this.getActiveHost();
        console.log('host apiUrl', host?.apiUrl);
        return host?.apiUrl || 'https://api.github.com';
    }

    private static async getDomain(): Promise<string> {
        const host = await this.getActiveHost();
        console.log('host domain', host?.domain);
        return host?.domain || 'https://github.com';
    }

    private static async getAuthToken(): Promise<string | null> {
        const host = await this.getActiveHost();
        if (host?.pat) {
            return host.pat;
        }
        const authState = await this.getAuthState();
        return authState.token;
    }

    static async getCurrentUser(token?: string): Promise<GitHubUser> {
        const apiUrl = await this.getApiUrl();
        const authToken = token || await this.getAuthToken();
        if (!authToken) throw new Error('No authentication token available');

        const response = await fetch(`${apiUrl}/user`, {
            headers: {
                Authorization: `Bearer ${authToken}`,
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
        const authToken = await this.getAuthToken();
        if (!authToken) throw new Error('Not authenticated');
        
        const apiUrl = await this.getApiUrl();
        const params = new URLSearchParams({
            state: options.state || 'open',
            sort: options.sort || 'created',
            direction: options.direction || 'desc',
            per_page: options.per_page?.toString() || '30',
            page: options.page?.toString() || '1'
        });
        console.log('apiUrl', apiUrl);
        const response = await fetch(
            `${apiUrl}/repos/${owner}/${repo}/pulls?${params}`,
            {
                headers: {
                    Authorization: `Bearer ${authToken}`,
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
        const domain = await this.getDomain();
        console.log('domain', domain);
        const response = await fetch(`${domain}/login/oauth/access_token`, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                client_id: CLIENT_ID,
                client_secret: CLIENT_SECRET,
                code,
            }),
        });

        if (!response.ok) {
            throw new Error('Failed to exchange code for token');
        }

        const data = await response.json();
        return data.access_token;
    }

    static async getCurrentUserPRs(owner: string, repo: string): Promise<GitHubPR[]> {
        const authToken = await this.getAuthToken();
        if (!authToken) throw new Error('Not authenticated');

        return this.getAllPullRequests(owner, repo, {
            state: 'open',
            sort: 'updated',
        });
    }
}
