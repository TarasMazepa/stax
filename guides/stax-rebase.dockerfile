FROM taras0mazepa/stax-guide-base:0.10.5

RUN touch fix-button.txt 
RUN stax commit -ab "fix button"

RUN touch fix-field.txt 
RUN stax commit -ab "fix field"

RUN stax move head
RUN touch README.md
RUN git add README.md
RUN git commit -m "Adds README.md"
RUN git push

RUN git checkout fix-button

RUN echo 'echo -e "\n===== stax rebase demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to rebase branch trees."' >> /home/stax/.bashrc
RUN echo 'echo "Run \"stax rebase\" to rebase fix-button onto updated main"' >> /home/stax/.bashrc
RUN echo 'echo -e "Check \"stax log\" to see the updated history\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc
