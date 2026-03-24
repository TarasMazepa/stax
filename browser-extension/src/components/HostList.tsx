import React from 'react';
import { HostConfig } from '../types/github';

interface HostListProps {
  hosts: HostConfig[];
  onToggle: (index: number) => void;
  onRemove: (index: number) => void;
}

export const HostList: React.FC<HostListProps> = ({ hosts, onToggle, onRemove }) => (
  <div className="space-y-2 pr-2">
    {/* Default GitHub.com host */}
    <div className="flex flex-row h-fit items-center space-x-3 bg-gray-800 p-4 rounded-lg shadow-md">
      <div className="flex-1 min-w-0">
        <div className="text-white font-medium truncate">https://github.com</div>
        <div className="text-sm text-gray-400 truncate">https://api.github.com</div>
      </div>
      <div className="flex flex-row items-center space-x-2 flex-shrink-0">
        <button
          className="px-3 py-2 rounded-lg transition-colors bg-green-500 text-white font-medium cursor-not-allowed opacity-75"
          disabled
        >
          Default
        </button>
      </div>
    </div>

    {/* Custom hosts */}
    {hosts.map((host, index) => (
      <div key={index} className="flex flex-row h-fit items-center space-x-3 bg-gray-800 p-4 rounded-lg shadow-md">
        <div className="flex-1 min-w-0">
          <div className="text-white font-medium truncate">{host.domain}</div>
          <div className="text-sm text-gray-400 truncate">{host.apiUrl}</div>
        </div>
        <div className="flex flex-row items-center space-x-2 flex-shrink-0">
          <button
            onClick={() => onToggle(index)}
            className={`px-3 py-2 rounded-lg transition-colors ${
              host.active
                ? 'bg-green-500 hover:bg-green-600'
                : 'bg-gray-600 hover:bg-gray-500'
            } text-white font-medium`}
          >
            {host.active ? 'Active' : 'Inactive'}
          </button>
          <button
            onClick={() => onRemove(index)}
            className="px-3 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition-colors"
          >
            Remove
          </button>
        </div>
      </div>
    ))}
  </div>
); 