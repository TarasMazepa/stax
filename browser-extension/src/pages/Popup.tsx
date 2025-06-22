import React, { useEffect, useMemo, useState } from 'react';
import browser from 'webextension-polyfill';
import { GitHubPR } from '../types/github';
import { TabBar } from '../components/TabBar';
import { UserProfile } from '../components/UserProfile';
import { PRList } from '../components/PRList';
import { HostForm } from '../components/HostForm';
import { HostList } from '../components/HostList';
import { useAuth } from '../hooks/useAuth';
import { useHosts } from '../hooks/useHosts';
import { useError } from '../hooks/useError';

type Tab = 'main' | 'hosts';

export default function Popup() {
    const [activeTab, setActiveTab] = useState<Tab>('main');
    const [prs, setPRs] = useState<GitHubPR[]>([]);
    
    const { authState, loading, handleLogin, handleLogout } = useAuth();
    const { hosts, newHost, setNewHost, saveHost, toggleHost, removeHost } = useHosts();
    const { error, setError, clearError } = useError();

    useEffect(() => {
        console.log('Extension OAuth Config:', {
            redirectUrl: browser.identity.getRedirectURL(),
            extensionId: browser.runtime.id,
        });
    }, []);

    const onLogin = async () => {
        const success = await handleLogin();
        if (!success) {
            setError('Login failed');
        } else {
            clearError();
        }
    };

    const onLogout = async () => {
        const success = await handleLogout();
        if (success) {
            setPRs([]);
            clearError();
        } else {
            setError('Logout failed');
        }
    };

    const onSaveHost = async () => {
        const result = await saveHost();
        if (!result.success) {
            setError(result.error || 'Failed to save host');
        } else {
            clearError();
        }
    };

    const onToggleHost = async (index: number) => {
        const success = await toggleHost(index);
        if (!success) {
            setError('Failed to update host');
        }
    };

    const onRemoveHost = async (index: number) => {
        const success = await removeHost(index);
        if (!success) {
            setError('Failed to remove host');
        }
    };

    const customActiveHosts = useMemo(() => hosts.find(h => h.active), [hosts]);

    if (loading) {
        return (
            <div className="flex items-center justify-center h-full">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
            </div>
        );
    }

    return (
        <div className="popup-container">
            <div className="min-h-full bg-gray-900 w-full">
                <TabBar activeTab={activeTab} onTabChange={setActiveTab} />

                {error && (
                    <div className="mx-4 my-3 h-fit bg-red-100 text-red-700 p-3 rounded-lg">
                        {error}
                    </div>
                )}

                <div className="space-y-4 w-full px-2">
                    {activeTab === 'main' ? (
                        <div className="space-y-4 h-[500px] flex flex-col justify-center items-center">
                            {(authState?.user || customActiveHosts) ? (
                                <>
                                    <UserProfile authState={authState} hostConfig={customActiveHosts} onLogout={onLogout} />
                                    {prs.length > 0 && <PRList prs={prs} />}
                                </>
                            ) : (
                                <button
                                    onClick={onLogin}
                                    className="w-full bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-lg transition-colors shadow-md font-medium"
                                >
                                    Login with GitHub
                                </button>
                            )}
                        </div>
                    ) : (
                        <div className="space-y-4 w-full">
                            <HostForm
                                newHost={newHost}
                                onHostChange={setNewHost}
                                onSave={onSaveHost}
                            />
                            <HostList
                                hosts={hosts}
                                onToggle={onToggleHost}
                                onRemove={onRemoveHost}
                            />
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}
