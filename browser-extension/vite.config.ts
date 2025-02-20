import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import webExtension, { readJsonFile } from "vite-plugin-web-extension";

function generateManifest() {
    const manifest = readJsonFile("src/manifest.json");
    const pkg = readJsonFile("package.json");
    return {
        name: pkg.name,
        description: pkg.description,
        version: pkg.version,
        key: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqF3QhKTBZCFh1mZqFNnxF9xKqxzWOXHVv0WdJJXcLFYz7Z2UXn2xH2oONWD7lUxjQv9fyVGXKO+s6vy9kXHpcUtMVdHtKtKakR/ynvtY+SF4L7O+lGy+yHQOhGEg4kz/RRUaEWeiHVLocOQmbgt8ZhU6A5BhqnWxzKA4GFXvYNt3IyQbL+8JMNX2KJ3Ot1qOYT6zFtA9KkYGF+P4iIRbqXzz7XLu4f0Kg9c3CvHhxpqTyFXhM4ANhMkOrHRVgJC5PAeNQg7GaJ8yEbKiOJqzM5oQhc8s9kLWHGJJ3UX6A1YGYqJKRkQnc4XhXhV/AZ4tUZgVzU0FBARQKZDRlQIDAQAB",
        ...manifest,
    };
}

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [
        react(),
        webExtension({
            manifest: generateManifest,
        }),
    ],
});
