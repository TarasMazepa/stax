FROM taras0mazepa/stax-guide-base:0.10.4

RUN touch login-page.txt
RUN stax commit -ab "login page refactor"
RUN touch button.txt
RUN stax commit -ab "new button component"
RUN touch registration.txt
RUN stax commit -ab "registration form"
RUN touch old-ui.txt
RUN stax commit -ab "outdated ui design"
RUN git checkout main

RUN git checkout main
RUN touch LICENSE.md
RUN git add LICENSE.md
RUN git commit -m "Adds LICENSE.md"
RUN git push

WORKDIR /home/stax/origin
RUN git branch -D registration-form outdated-ui-design

RUN echo 'echo -e "\n===== stax delete demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo has following branches:"' >> /home/stax/.bashrc
RUN echo 'echo -e "\n * login-page-refactor and new-button-component - branches with their remotes in tact"' >> /home/stax/.bashrc
RUN echo 'echo " * registration-form and outdated-ui-design - branches whose remote counterparts were deleted (gone)"' >> /home/stax/.bashrc
RUN echo 'echo -e "Run \"stax delete\" to see and cleanup local branches. Try out \"-f\" flag too!\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc

WORKDIR /home/stax/repo
RUN git fetch -p
