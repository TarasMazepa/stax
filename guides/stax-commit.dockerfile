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
    mkdir -p src && \
    echo "function app() { /* implementation */ }" > src/app.js && \
    echo "body { margin: 0; padding: 0; }" > src/styles.css && \
    echo "<!DOCTYPE html><html><body><h1>Demo App</h1></body></html>" > src/index.html && \
    git add src && \
    git commit -m "Add initial project files" && \
    git push origin main

RUN cd /home/stax/clone && \
    echo "function newFeature() { /* implementation */ }" >> src/app.js 


RUN mkdir -p /usr/local/bin && \
    echo '#!/bin/bash' > /usr/local/bin/open && \
    echo 'echo "===== BROWSER SIMULATION ====="' >> /usr/local/bin/open && \
    echo 'echo "Opening URL: $1"' >> /usr/local/bin/open && \
    echo 'echo "This would open a browser to create a pull request in a real environment."' >> /usr/local/bin/open && \
    echo 'echo "============================"' >> /usr/local/bin/open && \
    chmod +x /usr/local/bin/open

ENV ENV=/home/stax/.bashrc
ENV BROWSER=/usr/local/bin/open

WORKDIR /home/stax/clone
