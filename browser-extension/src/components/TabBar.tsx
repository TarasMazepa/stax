import React from 'react';
import { Tab } from '../types/github';

interface TabBarProps {
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
}

export const TabBar: React.FC<TabBarProps> = ({ activeTab, onTabChange }) => (
  <div className="flex flex-row w-full h-fit border-b border-gray-700 bg-gray-800 sticky top-0 z-10 p-2">
    <button
      className={`px-6 py-3 rounded-t-lg transition-all ${
        activeTab === 'main'
          ? 'text-blue-400 border-b-2 border-blue-400 bg-gray-700'
          : 'text-gray-400 hover:text-gray-300 hover:bg-gray-700'
      }`}
      onClick={() => onTabChange('main')}
    >
      Main
    </button>
    <button
      className={`px-6 py-3 rounded-t-lg transition-all ${
        activeTab === 'hosts'
          ? 'text-blue-400 border-b-2 border-blue-400 bg-gray-700'
          : 'text-gray-400 hover:text-gray-300 hover:bg-gray-700'
      }`}
      onClick={() => onTabChange('hosts')}
    >
      Hosts
    </button>
  </div>
); 