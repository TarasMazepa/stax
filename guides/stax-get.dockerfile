FROM taras0mazepa/stax:0.10.1

RUN mkdir -p /home/stax/remote /home/stax/clone1 /home/stax/clone2

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main

RUN cd /home/stax/remote && git init --bare

RUN cd /home/stax && git clone /home/stax/remote /home/stax/clone1

RUN cd /home/stax/clone1 && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN cd /home/stax && git clone /home/stax/remote /home/stax/clone2

RUN cd /home/stax/clone1 && \
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
    git push origin main

RUN cd /home/stax/clone1 && \
    git checkout -b feature-user-auth && \
    echo "function login() { /* auth implementation */ }" > src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add authentication module" && \
    echo "function register() { /* registration implementation */ }" >> src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add user registration" && \
    git push origin feature-user-auth

RUN cd /home/stax/clone1 && \
    git checkout feature-user-auth && \
    git checkout -b feature-oauth && \
    echo "function googleAuth() { /* Google OAuth */ }" >> src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add Google OAuth" && \
    echo "function facebookAuth() { /* Facebook OAuth */ }" >> src/auth.js && \
    git add src/auth.js && \
    git commit -m "Add Facebook OAuth" && \
    git push origin feature-oauth

RUN cd /home/stax/clone1 && \
    git checkout feature-oauth && \
    git checkout -b feature-security && \
    echo "function validateToken() { /* Token validation */ }" > src/security.js && \
    git add src/security.js && \
    git commit -m "Add token validation" && \
    echo "function encryptData() { /* Data encryption */ }" >> src/security.js && \
    git add src/security.js && \
    git commit -m "Add data encryption" && \
    git push origin feature-security

RUN cd /home/stax/clone1 && \
    git checkout feature-user-auth && \
    git checkout -b feature-user-profile && \
    echo "function getProfile() { /* Get user profile */ }" > src/profile.js && \
    git add src/profile.js && \
    git commit -m "Add user profile retrieval" && \
    echo "function updateProfile() { /* Update user profile */ }" >> src/profile.js && \
    git add src/profile.js && \
    git commit -m "Add profile update functionality" && \
    git push origin feature-user-profile

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
