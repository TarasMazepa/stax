FROM taras0mazepa/stax-guide-base:0.10.2

RUN echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push

RUN git checkout -b login-page-refactor && \
    # Branch 1 - will keep this one
    echo "Login page refactor changes" > login-page.txt && \
    git add login-page.txt && \
    git commit -m "Refactor login page implementation" && \
    git push && \
    # Branch 2 - will keep this one
    git checkout -b new-button-component && \
    echo "New reusable button component" > button.txt && \
    git add button.txt && \
    git commit -m "Add reusable button component" && \
    git push && \
    # Branch 3 - will delete this one from remote
    git checkout -b registration-form-not-working && \
    echo "Registration form bug fixes" > registration.txt && \
    git add registration.txt && \
    git commit -m "Fix registration form issues" && \
    git push && \
    # Branch 4 - will delete this one from remote
    git checkout -b outdated-ui-design && \
    echo "Old UI design implementation" > old-ui.txt && \
    git add old-ui.txt && \
    git commit -m "Implement outdated UI design" && \
    git push && \
    git checkout main

RUN git checkout main && \
    echo "Additional content" >> README.md && \
    git add README.md && \
    git commit -m "Update README" && \
    git push

RUN cd /home/stax/origin && \
    git branch -D registration-form-not-working && \
    git branch -D outdated-ui-design

RUN git fetch --prune && \
    echo "git branch -vv:" && \
    git branch -vv

RUN echo 'echo -e "\n===== stax delete demo =====\n"' > /home/stax/.bashrc && \
    echo 'echo "This demo has following branches:"' >> /home/stax/.bashrc && \
    echo 'echo -e "\n * login-page-refactor and new-button-component - branches with their remotes in tact"' >> /home/stax/.bashrc && \
    echo 'echo " * registration-form-not-working and outdated-ui-design - branches whose remote counterparts were deleted (gone)"' >> /home/stax/.bashrc && \
    echo 'echo -e "\nRun \"git branch -vv\" to see how git marks branches with gone remotes."' >> /home/stax/.bashrc && \
    echo 'echo -e "Run \"stax delete\" to see and cleanup local branches. Try out \"-f\" flag too!\n"' >> /home/stax/.bashrc && \
    echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc

WORKDIR /home/stax/repo
