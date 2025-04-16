FROM taras0mazepa/stax:0.10.1

RUN mkdir -p /home/stax/remote /home/stax/clone

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main

RUN cd /home/stax/remote && git init --bare

RUN cd /home/stax && git clone /home/stax/remote /home/stax/clone

RUN cd /home/stax/clone && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN git config --global --unset user.name && \
    git config --global --unset user.email 

WORKDIR /home/stax/clone
