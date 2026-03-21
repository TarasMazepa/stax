#!/bin/bash
set -e

# Change to the root of the project to ensure relative paths work consistently
cd "$(dirname "$0")/../.."

# Generate the content using showdown
CONTENT=$(npx -y showdown makehtml -i README.md)

cat << 'HTML_EOF' > guides/web/index.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light dark">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.zinc.min.css">
    <title>stax - manage your git branches and stack PRs</title>
</head>
<body>
<header>
    <nav>
        <ul>
            <li><a href="index.html"><strong>Stax for git</strong></a></li>
            by
            <li><a href="https://tarasmazepa.com" target="_blank">Taras Mazepa</a></li>
        </ul>
        <ul>
            <li><a href="guides.html">Try live in browser</a></li>
            <li><a href="help.html">Help</a></li>
            <li><a href="https://github.com/TarasMazepa/stax" target="_blank">GitHub</a></li>
        </ul>
    </nav>
</header>
<main>
    <article id="content">
HTML_EOF

echo "$CONTENT" >> guides/web/index.html

cat << 'HTML_EOF' >> guides/web/index.html
    </article>
</main>
<footer>
    <p style="text-align: center;">By <a href="https://tarasmazepa.com" target="_blank">Taras Mazepa</a></p>
</footer>
</body>
</html>
HTML_EOF

echo "Generated guides/web/index.html"
