FROM taras0mazepa/stax:0.10.1

RUN mkdir -p /home/stax/remote /home/stax/clone

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main

RUN cd /home/stax/remote && git init --bare

RUN cd /home/stax/remote && git symbolic-ref HEAD refs/heads/main

RUN cd /home/stax && git clone /home/stax/remote /home/stax/clone

RUN cd /home/stax/clone && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN cd /home/stax/clone && \
    git remote set-head origin main

RUN cd /home/stax/clone && \
    git checkout -b feature-branch && \
    echo "Feature branch changes" > feature.txt && \
    git add feature.txt && \
    git commit -m "Add feature implementation" && \
    git push -u origin feature-branch

RUN cd /home/stax && git clone /home/stax/remote /home/stax/second-clone && \
    cd /home/stax/second-clone && \
    echo "Changes from another developer" >> README.md && \
    git add README.md && \
    git commit -m "Update README from another developer" && \
    git push origin main && \
    echo "More changes from another developer" >> README.md && \
    git add README.md && \
    git commit -m "Another update to README from another developer" && \
    git push origin main

RUN cd /home/stax/clone && \
    git checkout -b temp-branch && \
    echo "Temporary work" > temp.txt && \
    git add temp.txt && \
    git commit -m "Add temporary file" && \
    git push -u origin temp-branch && \
    git checkout feature-branch

RUN cd /home/stax/remote && \
    git branch -D temp-branch

ENV ENV=/home/stax/.bashrc

WORKDIR /home/stax/clone
