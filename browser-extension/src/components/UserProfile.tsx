import React from 'react';
import { AuthState, HostConfig } from '../types/github';

interface UserProfileProps {
  authState?: AuthState | null;
  hostConfig?: HostConfig | null;
  onLogout: () => void;
}

export const UserProfile: React.FC<UserProfileProps> = ({ authState, hostConfig, onLogout }) => (
  <div className="flex items-center h-fit space-x-3 p-4 bg-gray-800 rounded-lg shadow-md">
    {authState?.user && !hostConfig && (
      <>
        <img
          src={authState.user?.avatar_url}
          alt="Profile"
          className="w-10 h-10 rounded-full border-2 border-blue-400"
    />
    <span className="text-white font-medium flex-1">{authState.user?.name}</span>
    <button
      onClick={onLogout}
      className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition-colors shadow-sm"
        >
          Logout
        </button>
      </>
    )}
    {hostConfig && (
      <>
        <div className="flex flex-col space-y-2">
          <span className="text-gray-300 text-sm font-medium">
            Using Custom Host Configuration
          </span>
          <div className="flex items-center space-x-2">
            <span className="text-blue-400 text-xs uppercase tracking-wider">Domain</span>
            <span className="text-white font-medium">{hostConfig.domain}</span>
          </div>
          <div className="flex items-center space-x-2">
            <span className="text-blue-400 text-xs uppercase tracking-wider">API URL</span>
            <span className="text-white font-medium">{hostConfig.apiUrl}</span>
          </div>
        </div>
      </>
    )}
  </div>
); 