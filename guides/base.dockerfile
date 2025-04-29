FROM taras0mazepa/stax:0.10.3

RUN mkdir -p /home/stax/origin /home/stax/repo /home/stax/setup

RUN git config --global user.email "stax@staxforgit.com"
RUN git config --global user.name "stax"
RUN git config --global init.defaultBranch main
RUN git config --global push.autoSetupRemote true

WORKDIR /home/stax/origin
RUN git init --bare

WORKDIR /home/stax/setup
RUN git clone /home/stax/origin .
RUN touch CONTRIBUTORS.md
RUN git add CONTRIBUTORS.md
RUN git commit -m "Initial commit"
RUN git push

WORKDIR /home/stax/repo
RUN rm -rf /home/stax/setup
RUN git clone /home/stax/origin .
