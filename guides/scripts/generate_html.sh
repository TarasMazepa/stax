#!/bin/bash
set -e

# Change to the root of the project to ensure relative paths work consistently
cd "$(dirname "$0")/../.."

echo "Downloading pico.classless.zinc.min.css..."
wget -q https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.classless.zinc.min.css -O guides/web/pico.classless.zinc.min.css

echo "Generating guides/web/help.html..."

# Run stax help and capture output
cd cli
HELP_OUTPUT=$(dart run bin/cli.dart help)
cd ..

# Generate help.html
cat << 'HTML_EOF' > guides/web/help.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light dark">
    <link rel="stylesheet" href="./pico.classless.zinc.min.css">
    <title>stax help - command reference</title>
    <style>
        pre {
            white-space: pre-wrap;
            word-wrap: break-word;
            padding: 1rem;
            background-color: var(--pico-code-background-color);
            border-radius: var(--pico-border-radius);
            font-family: monospace;
            font-size: 0.9em;
        }
        main {
            padding-top: 2rem;
        }
    </style>
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
            <li><a href="onboarding.html">Onboarding</a></li>
            <li><a href="agents.html">Agents</a></li>
            <li><a href="help.html">Help</a></li>
            <li><a href="https://github.com/TarasMazepa/stax" target="_blank">GitHub</a></li>
        </ul>
    </nav>
</header>
<main>
    <article id="content">
        <h1>Stax Command Reference</h1>
        <p>This is the output of the <code>stax help</code> command.</p>
        <pre id="help-content">
HTML_EOF

# HTML escape the help output
echo "$HELP_OUTPUT" | sed 's/</\&lt;/g' | sed 's/>/\&gt;/g' >> guides/web/help.html

cat << 'HTML_EOF' >> guides/web/help.html
        </pre>
    </article>
</main>
<footer>
    <p style="text-align: center;">By <a href="https://tarasmazepa.com" target="_blank">Taras Mazepa</a></p>
</footer>
</body>
</html>
HTML_EOF

echo "Generated guides/web/help.html"

echo "Generating guides/web/index.html..."

# Generate the content using showdown
CONTENT=$(npx -y showdown@2.1.0 makehtml -i README.md)
CONTENT="${CONTENT//guides\/onboarding.md/onboarding.html}"

cat << 'HTML_EOF' > guides/web/index.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light dark">
    <link rel="stylesheet" href="./pico.classless.zinc.min.css">
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
            <li><a href="onboarding.html">Onboarding</a></li>
            <li><a href="agents.html">Agents</a></li>
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

echo "Generating guides/web/onboarding.html..."

# Generate the content using showdown
ONBOARDING_CONTENT=$(npx -y showdown@2.1.0 makehtml -i guides/onboarding.md)

cat << 'HTML_EOF' > guides/web/onboarding.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light dark">
    <link rel="stylesheet" href="./pico.classless.zinc.min.css">
    <title>stax - onboarding guide for beginners</title>
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
            <li><a href="onboarding.html">Onboarding</a></li>
            <li><a href="agents.html">Agents</a></li>
            <li><a href="help.html">Help</a></li>
            <li><a href="https://github.com/TarasMazepa/stax" target="_blank">GitHub</a></li>
        </ul>
    </nav>
</header>
<main>
    <article id="content">
HTML_EOF

echo "$ONBOARDING_CONTENT" >> guides/web/onboarding.html

cat << 'HTML_EOF' >> guides/web/onboarding.html
    </article>
</main>
<footer>
    <p style="text-align: center;">By <a href="https://tarasmazepa.com" target="_blank">Taras Mazepa</a></p>
</footer>
</body>
</html>
HTML_EOF

echo "Generated guides/web/onboarding.html"

echo "Generating guides/web/agents.html..."

# Run stax extras agents.md and capture output
cd cli
AGENTS_OUTPUT=$(dart run bin/cli.dart extras agents.md)
cd ..

# Ensure we create a temporary file with markdown to be processed by showdown
echo "$AGENTS_OUTPUT" > /tmp/agents.md
AGENTS_CONTENT=$(npx -y showdown@2.1.0 makehtml -i /tmp/agents.md)

cat << 'HTML_EOF' > guides/web/agents.html
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light dark">
    <link rel="stylesheet" href="./pico.classless.zinc.min.css">
    <title>stax - agents.md</title>
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
            <li><a href="onboarding.html">Onboarding</a></li>
            <li><a href="agents.html">Agents</a></li>
            <li><a href="help.html">Help</a></li>
            <li><a href="https://github.com/TarasMazepa/stax" target="_blank">GitHub</a></li>
        </ul>
    </nav>
</header>
<main>
    <article id="content">
HTML_EOF

echo "$AGENTS_CONTENT" >> guides/web/agents.html

cat << 'HTML_EOF' >> guides/web/agents.html
    </article>
</main>
<footer>
    <p style="text-align: center;">By <a href="https://tarasmazepa.com" target="_blank">Taras Mazepa</a></p>
</footer>
</body>
</html>
HTML_EOF

echo "Generated guides/web/agents.html"
