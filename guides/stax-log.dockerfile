FROM taras0mazepa/stax:0.10.0

RUN mkdir -p /home/stax/log-demo

WORKDIR /home/stax/log-demo 

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main

RUN git init && \
    echo "# Project Documentation" > README.md && \
    git add README.md && \
    git commit -m "Initial commit: Project setup"

RUN git checkout -b feature-auth && \
    echo "# Authentication Module" > auth.md && \
    git add auth.md && \
    git commit -m "Add authentication module documentation" && \
    echo "function login() { /* ... */ }" > auth.js && \
    git add auth.js && \
    git commit -m "Implement basic login functionality"

RUN git checkout feature-auth && \
    git checkout -b feature-password-reset && \
    echo "function resetPassword() { /* ... */ }" >> auth.js && \
    git add auth.js && \
    git commit -m "Add password reset functionality" && \
    echo "# Password Reset Guide" > password-reset.md && \
    git add password-reset.md && \
    git commit -m "Add password reset documentation"

RUN git checkout main && \
    git checkout -b feature-ui && \
    echo "# UI Components" > ui.md && \
    git add ui.md && \
    git commit -m "Add UI components documentation" && \
    echo ".button { color: blue; }" > styles.css && \
    git add styles.css && \
    git commit -m "Add button styles"

RUN git checkout feature-ui && \
    git checkout -b feature-dark-theme && \
    echo ".dark-mode { background: #333; }" >> styles.css && \
    git add styles.css && \
    git commit -m "Implement dark theme" && \
    git checkout feature-ui && \
    git checkout -b feature-responsive && \
    echo "@media (max-width: 768px) { /* ... */ }" >> styles.css && \
    git add styles.css && \
    git commit -m "Add responsive styles"

RUN git checkout main && \
    echo "# Getting Started" >> README.md && \
    git add README.md && \
    git commit -m "Update README with getting started guide" && \
    git checkout -b release-v1 && \
    echo "version: 1.0.0" > version.txt && \
    git add version.txt && \
    git commit -m "Prepare v1.0 release"

RUN git checkout main && \
    git merge --no-ff feature-auth -m "Merge feature-auth into main"

RUN git checkout release-v1 && \
    git checkout -b hotfix-auth-bug && \
    echo "function login() { /* Fixed bug */ }" > auth-fix.js && \
    git add auth-fix.js && \
    git commit -m "Fix critical authentication bug"

RUN git checkout release-v1 && \
    git merge --no-ff hotfix-auth-bug -m "Merge hotfix into release-v1" && \
    git checkout main && \
    git merge --no-ff hotfix-auth-bug -m "Merge hotfix into main"

RUN git checkout main && \
    git checkout -b release-v2 && \
    echo "version: 2.0.0" > version.txt && \
    git add version.txt && \
    git commit -m "Prepare v2.0 release"

RUN git checkout main && \
    git merge --no-ff feature-ui -m "Merge feature-ui into main"

RUN git checkout main && \
    echo "# Contributing Guidelines" > CONTRIBUTING.md && \
    git add CONTRIBUTING.md && \
    git commit -m "Add contributing guidelines"

ENV ENV=/home/stax/.bashrc
