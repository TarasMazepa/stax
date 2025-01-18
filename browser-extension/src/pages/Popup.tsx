import browser from 'webextension-polyfill';
import { useEffect, useState } from 'react';
import "./Popup.css";

export default function Popup() {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Initialize component
    setLoading(false);
  }, []);

  if (loading) {
    return <div className="flex items-center justify-center h-full">Loading...</div>;
  }

  return (
    <div className="p-4">
      <h1>Browser Extension</h1>
      <p>Welcome to your new browser extension!</p>
    </div>
  );
}
