FROM taras0mazepa/stax:0.10.0

RUN mkdir -p /home/stax/clone /home/stax/remote

WORKDIR /home/stax/remote

RUN git init --bare

WORKDIR /home/stax/clone 

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main

RUN git init && \
    echo "# Project Documentation" > README.md && \
    git add README.md && \
    git commit -m "Initial commit: Project setup" && \
    git remote add origin /home/stax/remote && \
    git push -u origin main

RUN git checkout -b feature-auth && \
    echo "# Authentication Module" > auth.md && \
    git add auth.md && \
    git commit -m "Add authentication module documentation" && \
    echo "function login() { /* ... */ }" > auth.js && \
    git add auth.js && \
    git commit -m "Implement basic login functionality" && \
    git push -u origin feature-auth

RUN git checkout feature-auth && \
    git checkout -b feature-password-reset && \
    echo "function resetPassword() { /* ... */ }" >> auth.js && \
    git add auth.js && \
    git commit -m "Add password reset functionality" && \
    echo "# Password Reset Guide" > password-reset.md && \
    git add password-reset.md && \
    git commit -m "Add password reset documentation" && \
    git push -u origin feature-password-reset

RUN git checkout main && \
    git checkout -b feature-ui && \
    echo "# UI Components" > ui.md && \
    git add ui.md && \
    git commit -m "Add UI components documentation" && \
    echo ".button { color: blue; }" > styles.css && \
    git add styles.css && \
    git commit -m "Add button styles" && \
    git push -u origin feature-ui

RUN git checkout feature-ui && \
    git checkout -b feature-dark-theme && \
    echo ".dark-mode { background: #333; }" >> styles.css && \
    git add styles.css && \
    git commit -m "Implement dark theme" && \
    git push -u origin feature-dark-theme && \
    git checkout feature-ui && \
    git checkout -b feature-responsive && \
    echo "@media (max-width: 768px) { /* ... */ }" >> styles.css && \
    git add styles.css && \
    git commit -m "Add responsive styles" && \
    git push -u origin feature-responsive

RUN git checkout main && \
    echo "# Getting Started" >> README.md && \
    git add README.md && \
    git commit -m "Update README with getting started guide" && \
    git push origin main

ENV ENV=/home/stax/.bashrc
