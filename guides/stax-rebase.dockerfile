FROM taras0mazepa/stax-guide-base:0.10.3

RUN touch LICENSE.md
RUN git add LICENSE.md
RUN git commit -m "Adds LICENSE.md"
RUN git push

RUN touch fix-button.txt 
RUN stax commit -ab "fix button"

RUN mkdir -p /home/stax/second-repo
WORKDIR /home/stax/second-repo
RUN git clone /home/stax/origin .

RUN touch navigation.txt
RUN git add . && git commit -m "Adds navigation"
RUN git push

RUN touch login-page.txt
RUN git add . && git commit -m "Adds login-page"
RUN git push

WORKDIR /home/stax/repo
RUN stax pull

RUN echo 'echo -e "\n===== stax rebase demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to rebase branch trees."' >> /home/stax/.bashrc
RUN echo 'echo -e "\nWe have two cloned repositories:"' >> /home/stax/.bashrc
RUN echo 'echo " * /home/stax/repo - where we create fix-button branch"' >> /home/stax/.bashrc
RUN echo 'echo " * /home/stax/second-repo - where we add navigation and login page to main"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nRun \"stax pull\" to fetch changes from second-repo"' >> /home/stax/.bashrc
RUN echo 'echo "Run \"stax rebase\" to rebase fix-button onto updated main"' >> /home/stax/.bashrc
RUN echo 'echo -e "Check \"git log\" to see the updated history\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc