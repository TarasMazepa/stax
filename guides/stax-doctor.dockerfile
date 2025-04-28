FROM taras0mazepa/stax-guide-base:0.10.2

RUN echo "# Demo Repository" > README.md && \
    git add README.md && \
    git commit -m "Initial commit" && \
    git branch -M main && \
    git push -u origin main

RUN git config --global --unset user.name && \
    git config --global --unset user.email 

RUN git config --global push.autoSetupRemote false


