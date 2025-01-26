import browser from 'webextension-polyfill';
import { GitHubPR } from '../types/github';

export class GitHubContentService {
    private static async getAuthToken(): Promise<string | null> {
        const response = await browser.runtime.sendMessage({type: 'GET_AUTH_STATE'});
        return response?.token || null;
    }

    static async getPullRequests(owner: string, repo: string, options: {
        state?: 'open' | 'closed' | 'all';
        sort?: 'created' | 'updated' | 'popularity' | 'long-running';
        direction?: 'asc' | 'desc';
        per_page?: number;
        page?: number;
    } = {}): Promise<GitHubPR[]> {
        const token = await this.getAuthToken();
        if (!token) throw new Error('Not authenticated');

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

    static async getAllPullRequests(owner: string, repo: string, options: {
        state?: 'open' | 'closed' | 'all';
        sort?: 'created' | 'updated' | 'popularity' | 'long-running';
        direction?: 'asc' | 'desc';
    } = {}): Promise<GitHubPR[]> {
        const allPRs: GitHubPR[] = [];
        let page = 1;
        const PER_PAGE = 100;

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
} 
