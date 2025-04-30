FROM taras0mazepa/stax-guide-base:0.10.3

RUN mkdir -p /home/stax/second-repo
WORKDIR /home/stax/second-repo
RUN git clone /home/stax/origin .

RUN touch login-page.txt
RUN stax commit -ab "login page refactor"

WORKDIR /home/stax/repo

RUN touch registration.txt
RUN stax commit -ab "registration form not working"
RUN touch old-ui.txt
RUN stax commit -ab "outdated ui design"
RUN git checkout main

RUN git checkout main
RUN touch button.txt
RUN git add button.txt
RUN git commit -m "new button component"
RUN git push

WORKDIR /home/stax/origin
RUN git branch -D registration-form-not-working outdated-ui-design

WORKDIR /home/stax/repo
