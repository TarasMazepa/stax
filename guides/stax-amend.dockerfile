FROM taras0mazepa/stax:0.10.1

RUN mkdir -p /home/stax/remote /home/stax/clone

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main && \
    git config --global push.autoSetupRemote true

RUN cd /home/stax/remote && git init --bare

RUN cd /home/stax && git clone /home/stax/remote /home/stax/clone

RUN cd /home/stax/clone && \
    echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN cd /home/stax/clone && \
    git checkout -b feature-navigation && \
    mkdir -p src/components && \
    echo "function NavBar() { /* initial implementation */ }" > src/components/NavBar.js && \
    git add src/components/NavBar.js && \
    git commit -m "Add navigation bar component" && \
    git push origin feature-navigation

RUN cd /home/stax/clone && \
    echo "function NavItem() { /* implementation */ }" >> src/components/NavBar.js && \
    echo ".navbar { display: flex; }" > src/components/NavBar.css

WORKDIR /home/stax/clone
