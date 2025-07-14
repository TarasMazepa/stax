import { useState, useEffect } from 'react';
import browser from 'webextension-polyfill';
import { GitHubService } from '../services/github';
import { AuthState } from '../types/github';

export const useAuth = () => {
    const [authState, setAuthState] = useState<AuthState | null>(null);
    const [loading, setLoading] = useState(true);

    const loadAuthState = async () => {
        try {
            const state = await browser.storage.local.get(['authState']);
            setAuthState(state.authState || { token: null, user: null, customDomain: 'github.com' });
        } finally {
            setLoading(false);
        }
    };

    const handleLogin = async () => {
        setLoading(true);
        try {
            const newAuthState = await GitHubService.login();
            setAuthState(newAuthState);
            return true;
        } catch (err) {
            console.log('Login failed', err);
            return false;
        } finally {
            setLoading(false);
        }
    };

    const handleLogout = async () => {
        try {
            await GitHubService.logout();
            setAuthState(null);
            return true;
        } catch (err) {
            return false;
        }
    };

    useEffect(() => {
        loadAuthState();
    }, []);

    return {
        authState,
        loading,
        handleLogin,
        handleLogout
    };
}; 