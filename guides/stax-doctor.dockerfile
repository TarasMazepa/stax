FROM taras0mazepa/stax-guide-base:0.10.5

RUN git config --global --unset user.name
RUN git config --global --unset user.email 
RUN git config --global --unset push.autoSetupRemote
