FROM taras0mazepa/stax-guide-base:0.10.2

RUN git config --global --unset user.name && \
    git config --global --unset user.email 

RUN git config --global push.autoSetupRemote false
