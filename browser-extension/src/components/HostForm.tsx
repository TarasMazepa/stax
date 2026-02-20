import React from 'react';
import { HostConfig } from '../types/github';

interface HostFormProps {
  newHost: HostConfig;
  onHostChange: (host: HostConfig) => void;
  onSave: () => void;
}

export const HostForm: React.FC<HostFormProps> = ({ newHost, onHostChange, onSave }) => (
  <div className="p-2 w-full h-fit bg-gray-800 rounded shadow-sm">
    <input
      type="text" 
      placeholder="Domain (https://github.company.com)"
      value={newHost.domain}
      onChange={(e) => onHostChange({ ...newHost, domain: e.target.value })}
      className="w-full p-1 mb-1 bg-gray-700 rounded text-white text-sm border-gray-600"
    />
    <input
      type="text"
      placeholder="API URL (https://github.company.com/api/v3)" 
      value={newHost.apiUrl}
      onChange={(e) => onHostChange({ ...newHost, apiUrl: e.target.value })}
      className="w-full p-1 mb-1 bg-gray-700 rounded text-white text-sm border-gray-600"
    />
    <input
      type="password"
      placeholder="Personal Access Token (required for custom hosts)"
      value={newHost.pat || ''}
      onChange={(e) => onHostChange({ ...newHost, pat: e.target.value })}
      className="w-full p-1 mb-1 bg-gray-700 rounded text-white text-sm border-gray-600"
    />
    <button
      onClick={onSave}
      className="w-full bg-blue-500 text-white p-1 rounded text-sm"
    >
      Add
    </button>
  </div>
);