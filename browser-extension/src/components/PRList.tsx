import React from 'react';
import { GitHubPR } from '../types/github';

interface PRListProps {
  prs: GitHubPR[];
}

export const PRList: React.FC<PRListProps> = ({ prs }) => (
  <div className="space-y-3">
    <h2 className="text-lg text-white font-semibold px-1">Your Pull Requests</h2>
    <div className="space-y-2">
      {prs.map(pr => (
        <a
          key={pr.number}
          href={pr.html_url}
          target="_blank"
          rel="noopener noreferrer"
          className="block p-4 bg-gray-800 rounded-lg hover:bg-gray-700 transition-colors shadow-md"
        >
          <div className="flex items-center space-x-2">
            <span className="text-blue-400 font-mono">#{pr.number}</span>
            <span className="text-white flex-1">{pr.title}</span>
          </div>
          <div className="text-sm text-gray-400 mt-2 font-mono">
            {pr.base.ref} ← {pr.head.ref}
          </div>
        </a>
      ))}
    </div>
  </div>
); 