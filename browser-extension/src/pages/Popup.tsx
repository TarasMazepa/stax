import browser from 'webextension-polyfill';
import { useEffect, useState } from 'react';
import { GitHubService } from '../services/github';
import { AuthState, GitHubPR } from '../types/github';
import "./Popup.css";

export default function Popup() {
  const [authState, setAuthState] = useState<AuthState | null>(null);
  const [prs, setPRs] = useState<GitHubPR[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    console.log('Extension OAuth Config:', {
      redirectUrl: browser.identity.getRedirectURL(),
      extensionId: browser.runtime.id,
    });
    
    loadAuthState();
  }, []);

  const loadAuthState = async () => {
    try {
      const state = await browser.storage.local.get(['authState']);
      setAuthState(state.authState || { token: null, user: null, customDomain: 'github.com' });
    } catch (err) {
      setError('Failed to load auth state');
    } finally {
      setLoading(false);
    }
  };

  const handleLogin = async () => {
    try {
      setLoading(true);
      const newAuthState = await GitHubService.login();
      setAuthState(newAuthState);
      setError(null);
    } catch (err) {
      setError('Login failed');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    try {
      await GitHubService.logout();
      setAuthState(null);
      setPRs([]);
      setError(null);
    } catch (err) {
      setError('Logout failed');
    }
  };

  if (loading) {
    return <div className="flex items-center justify-center h-full">Loading...</div>;
  }

  return (
    <div className="p-4">
      {error && (
        <div className="bg-red-100 text-red-700 p-2 rounded mb-4">
          {error}
        </div>
      )}

      {authState?.user ? (
        <div className="space-y-4">
          <div className="flex items-center space-x-2">
            <img 
              src={authState.user.avatar_url} 
              alt="Profile" 
              className="w-8 h-8 rounded-full"
            />
            <span className="text-white">{authState.user.name}</span>
            <button 
              onClick={handleLogout}
              className="ml-auto bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded"
            >
              Logout
            </button>
          </div>

          {prs.length > 0 && (
            <div className="space-y-2">
              <h2 className="text-lg text-white font-semibold">Your Pull Requests</h2>
              {prs.map(pr => (
                <a 
                  key={pr.number}
                  href={pr.html_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="block p-2 bg-gray-800 rounded hover:bg-gray-700"
                >
                  <div className="text-white">#{pr.number} {pr.title}</div>
                  <div className="text-sm text-gray-400">
                    {pr.base.ref} ← {pr.head.ref}
                  </div>
                </a>
              ))}
            </div>
          )}
        </div>
      ) : (
        <button
          onClick={handleLogin}
          className="w-full bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded"
        >
          Login with GitHub
        </button>
      )}
    </div>
  );
}
