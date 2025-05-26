FROM taras0mazepa/stax-guide-base:0.10.4

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

RUN touch login-page.txt 
RUN stax commit -ab "login page"

RUN touch login-page-refactor.txt

RUN echo 'echo -e "\n===== stax amend demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to use stax amend command:"' >> /home/stax/.bashrc
RUN echo 'echo -e "\n * stax amend -A - adds tracked and untracked files in whole working tree before amending"' >> /home/stax/.bashrc
RUN echo 'echo " * stax amend -a - adds tracked and untracked files in current folder before amending"' >> /home/stax/.bashrc
RUN echo 'echo " * stax amend -u - adds only tracked files in whole working tree before amending"' >> /home/stax/.bashrc
RUN echo 'echo " * stax amend -r - runs rebase afterwards on all children branches"' >> /home/stax/.bashrc
RUN echo 'echo " * stax amend -m - runs rebase with prefer-moving afterwards on children"' >> /home/stax/.bashrc
RUN echo 'echo " * stax amend -b - runs rebase with prefer-base afterwards on children"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nTry updating the changes by running \"stax amend -u\"\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc