FROM taras0mazepa/stax:0.10.1

RUN mkdir -p /home/stax/origin /home/stax/repo

RUN git config --global user.email "stax@staxforgit.com" && \
    git config --global user.name "stax" && \
    git config --global init.defaultBranch main \
    git config --global push.autoSetupRemote true

RUN cd /home/stax/origin && git init --bare

RUN cd /home/stax && git clone /home/stax/origin /home/stax/repo

WORKDIR /home/stax/repo
