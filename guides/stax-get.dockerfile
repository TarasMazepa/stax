FROM taras0mazepa/stax-guide-base:0.10.2

RUN mkdir -p /home/stax/clone2

RUN cd /home/stax/repo && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git push

RUN cd /home/stax && git clone /home/stax/origin /home/stax/clone2

RUN cd /home/stax/repo && \
    mkdir -p src && \
    echo "function app() { /* implementation */ }" > src/app.js && \
    git add src/app.js && \
    git commit -m "Add app.js with basic structure" && \
    echo "/* App styles */" > src/styles.css && \
    git add src/styles.css && \
    git commit -m "Add basic stylesheet" && \
    echo "<!DOCTYPE html><html><body><h1>Demo App</h1></body></html>" > src/index.html && \
    git add src/index.html && \
    git commit -m "Add HTML index file" && \
    git push

RUN cd /home/stax/repo && \
    git checkout -b feature-user-auth && \
    echo "function login() { /* auth implementation */ }" > src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add authentication module" && \
    echo "function register() { /* registration implementation */ }" >> src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add user registration" && \
    git push

RUN cd /home/stax/repo && \
    git checkout feature-user-auth && \
    git checkout -b feature-oauth && \
    echo "function googleAuth() { /* Google OAuth */ }" >> src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add Google OAuth" && \
    echo "function facebookAuth() { /* Facebook OAuth */ }" >> src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add Facebook OAuth" && \
    git push

RUN cd /home/stax/repo && \
    git checkout feature-oauth && \
    git checkout -b feature-security && \
    echo "function validateToken() { /* Token validation */ }" > src/security.js && \
    git add src/security.js && \
    git commit -m "Add token validation" && \
    echo "function encryptData() { /* Data encryption */ }" >> src/security.js && \
    git add src/security.js && \
    git commit -m "Add data encryption" && \
    git push

RUN cd /home/stax/repo && \
    git checkout feature-user-auth && \
    git checkout -b feature-user-profile && \
    echo "function getProfile() { /* Get user profile */ }" > src/profile.js && \
    git add src/profile.js && \
    git commit -m "Add user profile retrieval" && \
    echo "function updateProfile() { /* Update user profile */ }" >> src/profile.js && \
    git add src/profile.js && \
    git commit -m "Add profile update functionality" && \
    git push

RUN cd /home/stax/clone2 && \
    git fetch origin && \
    git checkout main && \
    git checkout -b feature-user-auth origin/feature-user-auth && \
    git checkout -b feature-oauth origin/feature-oauth && \
    git checkout -b feature-security origin/feature-security && \
    git checkout -b feature-user-profile origin/feature-user-profile && \
    git checkout main

ENV ENV=/home/stax/clone2/.bashrc

WORKDIR /home/stax/clone2
