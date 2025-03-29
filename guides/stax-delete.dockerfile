FROM homebrew/brew

RUN brew install TarasMazepa/stax/stax

RUN mkdir -p /home/linuxbrew/repo-bare /home/linuxbrew/repo-local

RUN cd /home/linuxbrew/repo-bare && git init --bare

RUN cd /home/linuxbrew && git clone /home/linuxbrew/repo-bare /home/linuxbrew/repo-local

RUN cd /home/linuxbrew/repo-local && \
    git config --global user.email "demo@example.com" && \
    git config --global user.name "Demo User" && \
    git config --global init.defaultBranch master

RUN cd /home/linuxbrew/repo-local && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git push origin master

RUN cd /home/linuxbrew/repo-local && \
    # Branch 1 - will keep this one
    git checkout -b feature-1 && \
    echo "Feature 1 content" > feature1.txt && \
    git add feature1.txt && \
    git commit -m "Add feature 1" && \
    git push -u origin feature-1 && \
    # Branch 2 - will keep this one
    git checkout -b feature-2 && \
    echo "Feature 2 content" > feature2.txt && \
    git add feature2.txt && \
    git commit -m "Add feature 2" && \
    git push -u origin feature-2 && \
    # Branch 3 - will delete this one from remote
    git checkout -b feature-3 && \
    echo "Feature 3 content" > feature3.txt && \
    git add feature3.txt && \
    git commit -m "Add feature 3" && \
    git push -u origin feature-3 && \
    # Branch 4 - will delete this one from remote
    git checkout -b feature-4 && \
    echo "Feature 4 content" > feature4.txt && \
    git add feature4.txt && \
    git commit -m "Add feature 4" && \
    git push -u origin feature-4 && \
    git checkout master

RUN cd /home/linuxbrew/repo-local && \
    git checkout master && \
    echo "Additional content" >> README.md && \
    git add README.md && \
    git commit -m "Update README" && \
    git push origin master

RUN cd /home/linuxbrew/repo-bare && \
    git branch -D feature-3 && \
    git branch -D feature-4

RUN cd /home/linuxbrew/repo-local && \
    git fetch --prune && \
    echo "Branches with tracking info:" && \
    git branch -vv

RUN echo 'echo -e "\n===== STAX DELETE DEMO =====\n"' > /home/linuxbrew/.bashrc && \
    echo 'echo "This demo has branches with remote tracking information:"' >> /home/linuxbrew/.bashrc && \
    echo 'echo -e "\n* feature-1 and feature-2: normal branches with remote tracking"' >> /home/linuxbrew/.bashrc && \
    echo 'echo "* feature-3 and feature-4: branches whose remote counterparts were deleted (gone)"' >> /home/linuxbrew/.bashrc && \
    echo 'echo -e "\nRun \"git branch -vv\" to see branch status"' >> /home/linuxbrew/.bashrc && \
    echo 'echo -e "Run \"stax delete\" to see and remove gone branches\n"' >> /home/linuxbrew/.bashrc && \
    echo 'cd /home/linuxbrew/repo-local' >> /home/linuxbrew/.bashrc

WORKDIR /home/linuxbrew/repo-local
