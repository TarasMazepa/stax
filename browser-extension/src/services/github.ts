import browser from 'webextension-polyfill';
import { AuthState, GitHubPR, GitHubUser } from '../types/github';

const CLIENT_ID = import.meta.env.VITE_GITHUB_CLIENT_ID;
const CLIENT_SECRET = import.meta.env.VITE_GITHUB_CLIENT_SECRET;
const PRS_PER_PAGE: number = 100;

export class GitHubService {

    private static async getAuthState(): Promise<AuthState> {
        const result = await browser.storage.local.get(['authState']);
        return result.authState || {token: null, user: null, customDomain: 'github.com'};
    }

    private static async setAuthState(state: AuthState): Promise<void> {
        await browser.storage.local.set({authState: state});
    }

    private static async getAuthToken(): Promise<string | null> {
        const response = await browser.runtime.sendMessage({type: 'GET_AUTH_STATE'});
        return response?.token || null;
    }

    static async login(): Promise<AuthState> {
        const state = Math.random().toString(36).substring(7);
        const authUrl = new URL('https://github.com/login/oauth/authorize');

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

            const authState = {token, user, customDomain: 'github.com'};
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
        await this.setAuthState({token: null, user: null, customDomain: 'github.com'});
    }

    static async getCurrentUser(token: string): Promise<GitHubUser> {
        const response = await fetch('https://api.github.com/user', {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });
        return response.json();
    }

    static async getPullRequests(owner: string, repo: string, page: number = 1): Promise<GitHubPR[]> {
        const token = await this.getAuthToken();
        if (!token) throw new Error('Not authenticated');

        const params = new URLSearchParams({
            state: 'open',
            sort: 'updated',
            direction: 'desc',
            per_page: PRS_PER_PAGE.toString(),
            page: page.toString(),
        });

        const response = await fetch(
            `https://api.github.com/repos/${owner}/${repo}/pulls?${params}`,
            {
                headers: {
                    Authorization: `Bearer ${token}`,
                    Accept: 'application/vnd.github.v3+json',
                },
            }
        );

        if (!response.ok) {
            throw new Error(`Failed to fetch pull requests: ${response.statusText}`);
        }

        return response.json();
    }

    static async getAllPullRequests(owner: string, repo: string): Promise<GitHubPR[]> {
        const allPRs: GitHubPR[] = [];
        let page = 1;

        while (true) {
            const prs = await this.getPullRequests(owner, repo, page);

            if (prs.length === 0) break;

            allPRs.push(...prs);

            if (prs.length < PRS_PER_PAGE) break;
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

        return this.getAllPullRequests(owner, repo);
    }
}
