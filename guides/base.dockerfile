FROM taras0mazepa/stax:0.10.1

RUN mkdir -p /home/stax/origin /home/stax/repo

RUN git config --global user.email "stax@staxforgit.com"
RUN git config --global user.name "stax"
RUN git config --global init.defaultBranch main
RUN git config --global push.autoSetupRemote true

WORKDIR /home/stax/origin
RUN git init --bare

WORKDIR /home/stax
RUN git clone /home/stax/origin /home/stax/repo

WORKDIR /home/stax/repo
