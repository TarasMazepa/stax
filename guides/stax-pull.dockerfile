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

RUN mkdir -p /home/stax/second-repo
WORKDIR /home/stax/second-repo
RUN git clone /home/stax/origin .

RUN touch login-page.txt
RUN git add login-page.txt
RUN git commit -m "login page"
RUN git push

RUN touch remember-password.txt
RUN git add remember-password.txt
RUN git commit -m "remember password"
RUN git push

WORKDIR /home/stax/repo

RUN touch registration.txt
RUN stax commit -ab "registration form not working"
RUN touch old-ui.txt
RUN stax commit -ab "outdated ui design"
RUN touch ui-update.txt
RUN stax commit -ab "ui update"

WORKDIR /home/stax/origin
RUN git branch -D registration-form-not-working outdated-ui-design

WORKDIR /home/stax/repo
RUN git fetch

RUN echo 'echo -e "\n===== stax pull demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to update your local repository:"' >> /home/stax/.bashrc
RUN echo 'echo -e "\n * Run \"stax pull\" to switch to remote HEAD, pull latest changes, and return to your branch"' >> /home/stax/.bashrc
RUN echo 'echo " * Use \"stax pull -f\" to also clean up any local branches whose remotes were deleted"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nTry running \"git branch -vv\" before and after to see the changes!\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc