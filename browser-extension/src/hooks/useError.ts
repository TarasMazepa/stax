import { useState } from 'react';

export const useError = () => {
    const [error, setError] = useState<string | null>(null);

    const clearError = () => setError(null);
    const setErrorMessage = (message: string) => setError(message);

    return {
        error,
        setError: setErrorMessage,
        clearError
    };
}; 