FROM homebrew/brew

RUN brew install TarasMazepa/stax/stax

RUN mkdir -p /home/linuxbrew/remote /home/linuxbrew/clone

RUN cd /home/linuxbrew/remote && git init --bare

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main

RUN cd /home/linuxbrew && git clone /home/linuxbrew/remote /home/linuxbrew/clone

RUN cd /home/linuxbrew/clone && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN cd /home/linuxbrew/clone && \
    # Branch 1 - will keep this one
    git checkout -b login-page-refactor && \
    echo "Login page refactor changes" > login-page.txt && \
    git add login-page.txt && \
    git commit -m "Refactor login page implementation" && \
    git push -u origin login-page-refactor && \
    # Branch 2 - will keep this one
    git checkout -b new-button-component && \
    echo "New reusable button component" > button.txt && \
    git add button.txt && \
    git commit -m "Add reusable button component" && \
    git push -u origin new-button-component && \
    # Branch 3 - will delete this one from remote
    git checkout -b registration-form-not-working && \
    echo "Registration form bug fixes" > registration.txt && \
    git add registration.txt && \
    git commit -m "Fix registration form issues" && \
    git push -u origin registration-form-not-working && \
    # Branch 4 - will delete this one from remote
    git checkout -b outdated-ui-design && \
    echo "Old UI design implementation" > old-ui.txt && \
    git add old-ui.txt && \
    git commit -m "Implement outdated UI design" && \
    git push -u origin outdated-ui-design && \
    git checkout main

RUN cd /home/linuxbrew/clone && \
    git checkout main && \
    echo "Additional content" >> README.md && \
    git add README.md && \
    git commit -m "Update README" && \
    git push origin main

RUN cd /home/linuxbrew/remote && \
    git branch -D registration-form-not-working && \
    git branch -D outdated-ui-design

RUN cd /home/linuxbrew/clone && \
    git fetch --prune && \
    echo "git branch -vv:" && \
    git branch -vv

RUN echo 'echo -e "\n===== stax delete demo =====\n"' > /home/linuxbrew/.bashrc && \
    echo 'echo "This demo has following branches:"' >> /home/linuxbrew/.bashrc && \
    echo 'echo -e "\n * login-page-refactor and new-button-component - branches with their remotes still in tact"' >> /home/linuxbrew/.bashrc && \
    echo 'echo " * registration-form-not-working and outdated-ui-design - branches whose remote counterparts were deleted (gone)"' >> /home/linuxbrew/.bashrc && \
    echo 'echo -e "\nRun \"git branch -vv\" to see how git marks branches with gone remotes."' >> /home/linuxbrew/.bashrc && \
    echo 'echo -e "Run \"stax delete\" to see and cleanup local branches. Try out \"-f\" flag too!\n"' >> /home/linuxbrew/.bashrc && \
    echo 'cd /home/linuxbrew/clone' >> /home/linuxbrew/.bashrc

WORKDIR /home/linuxbrew/clone
