FROM taras0mazepa/stax-guide-base:0.10.3

RUN touch README.md
RUN git add README.md
RUN git commit -m "Initial commit"
RUN git branch -M main
RUN git push

RUN git checkout main
RUN touch LICENSE.md
RUN git add LICENSE.md
RUN git commit -m "Adds LICENSE.md"
RUN git push

RUN stax settings set branch_prefix "feature/" 

WORKDIR /home/stax/repo

RUN echo 'echo -e "\n===== stax settings demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to use stax settings command:"' >> /home/stax/.bashrc
RUN echo 'echo -e "\n * branch_prefix - Prefix added to all new branch names (e.g., \"feature/\")"' >> /home/stax/.bashrc
RUN echo 'echo " * default_branch - Override for default branch (empty means use <remote>/HEAD)"' >> /home/stax/.bashrc
RUN echo 'echo " * default_remote - Override for default remote (empty means use first available)"' >> /home/stax/.bashrc
RUN echo 'echo " * base_branch_replacement - Auto-substitute specific branch when creating PR"' >> /home/stax/.bashrc
RUN echo 'echo " * additionally_pull - Additional branches to pull besides default_branch"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nCommands:"' >> /home/stax/.bashrc
RUN echo 'echo " * stax settings set <name> <value> - Set a single value"' >> /home/stax/.bashrc
RUN echo 'echo " * stax settings add <name> <value> - Add to a list setting"' >> /home/stax/.bashrc
RUN echo 'echo " * stax settings remove <name> <value> - Remove from a list setting"' >> /home/stax/.bashrc
RUN echo 'echo " * stax settings clear <name> - Clear a setting"' >> /home/stax/.bashrc
RUN echo 'echo " * stax settings show - Show all settings"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nFlags:"' >> /home/stax/.bashrc
RUN echo 'echo " -g, --global - Perform operation on global settings regardless of invocation path"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nTry setting branch_prefix: \"stax settings set branch_prefix feature/\"\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc