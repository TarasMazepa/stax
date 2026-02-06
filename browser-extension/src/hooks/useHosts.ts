import { useState, useEffect } from 'react';
import browser from 'webextension-polyfill';
import { HostConfig } from '../types/github';

export const useHosts = () => {
    const [hosts, setHosts] = useState<HostConfig[]>([]);
    const [newHost, setNewHost] = useState<HostConfig>({
        domain: '',
        apiUrl: '',
        active: true,
        pat: ''
    });

    const loadHosts = async () => {
        try {
            const result = await browser.storage.local.get(['hosts']);
            setHosts(result.hosts || []);
            return true;
        } catch (err) {
            return false;
        }
    };

    const saveHost = async () => {
        try {
            if (!newHost.domain || !newHost.apiUrl) {
                return { success: false, error: 'Domain and API URL are required' };
            }

            if (newHost.domain !== 'github.com' && !newHost.pat) {
                return { success: false, error: 'Personal Access Token (PAT) is required for custom hosts' };
            }

            const updatedHosts = [...hosts, newHost];
            await browser.storage.local.set({ hosts: updatedHosts });
            setHosts(updatedHosts);
            setNewHost({ domain: '', apiUrl: '', active: true, pat: '' });
        
            await browser.permissions.request({
                origins: [
                    `${newHost.domain}/*`,
                    `${newHost.apiUrl}/*`
                ]
            });

            await browser.runtime.reload();
            return { success: true };
        } catch (err) {
            console.log('Failed to save host', err);
            return { success: false, error: 'Failed to save host' };
        }
    };

    const toggleHost = async (index: number) => {
        try {
            const updatedHosts = [...hosts];
            updatedHosts[index].active = !updatedHosts[index].active;
            await browser.storage.local.set({ hosts: updatedHosts });
            setHosts(updatedHosts);
            return true;
        } catch (err) {
            return false;
        }
    };

    const removeHost = async (index: number) => {
        try {
            const updatedHosts = hosts.filter((_, i) => i !== index);
            await browser.storage.local.set({ hosts: updatedHosts });
            setHosts(updatedHosts);
            return true;
        } catch (err) {
            return false;
        }
    };

    useEffect(() => {
        loadHosts();
    }, []);

    return {
        hosts,
        newHost,
        setNewHost,
        saveHost,
        toggleHost,
        removeHost
    };
}; 