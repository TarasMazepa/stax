FROM taras0mazepa/stax-guide-base:0.10.5

RUN touch LICENSE.md
RUN git add LICENSE.md
RUN git commit -m "Adds LICENSE.md"
RUN git push

RUN git checkout -b login-feature
RUN touch login-page.txt
RUN git add login-page.txt
RUN git commit -m "Add login page"
RUN git push -u origin login-feature

RUN git checkout -b remember-password-feature
RUN touch remember-password.txt
RUN git add remember-password.txt
RUN git commit -m "Add remember password functionality"
RUN git push -u origin remember-password-feature

RUN git checkout -b registration-feature
RUN touch registration.txt
RUN git add registration.txt
RUN git commit -m "Add registration form"
RUN git push -u origin registration-feature

RUN git checkout -b ui-feature
RUN touch ui-update.txt
RUN git add ui-update.txt
RUN git commit -m "Update UI design"
RUN git push -u origin ui-feature

RUN git checkout -b dark-theme-feature
RUN touch dark-theme.txt
RUN git add dark-theme.txt
RUN git commit -m "Add dark theme support"
RUN git push -u origin dark-theme-feature

RUN mkdir -p /home/stax/second-repo
WORKDIR /home/stax/second-repo
RUN git clone /home/stax/origin .

RUN touch login-page.txt
RUN git add login-page.txt
RUN git commit -m "login page"
RUN git push

RUN git checkout login-feature
RUN echo "Added login validation" >> login-page.txt
RUN git add login-page.txt
RUN git commit -m "Add login validation"
RUN git push

RUN git checkout remember-password-feature  
RUN echo "Added password encryption" >> remember-password.txt
RUN git add remember-password.txt && git commit -m "Add password encryption" && git push

RUN git checkout registration-feature
RUN echo "Added email validation" >> registration.txt
RUN git add registration.txt && git commit -m "Add email validation" && git push

RUN git checkout ui-feature
RUN echo "Updated button styles" >> ui-update.txt
RUN git add ui-update.txt && git commit -m "Update button styles" && git push

RUN git checkout dark-theme-feature
RUN echo "Added theme switcher" >> dark-theme.txt
RUN git add dark-theme.txt && git commit -m "Add theme switcher" && git push

WORKDIR /home/stax/repo
RUN git fetch

RUN echo 'echo -e "\n===== stax get demo =====\n"' > /home/stax/.bashrc
RUN echo 'echo "This demo shows how to use stax get command:"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nstax get <branch-name> - (Re)Checkout specified branch and all its children && pull latest changes"' >> /home/stax/.bashrc
RUN echo 'echo " * The branch name will be matched as a suffix"' >> /home/stax/.bashrc
RUN echo 'echo " * For example: stax get main - will checkout main branch"' >> /home/stax/.bashrc
RUN echo 'echo " * For example: stax get feature - will checkout any branch ending with feature"' >> /home/stax/.bashrc
RUN echo 'echo -e "\nTry checking out the main branch by running \"stax get main\"\n"' >> /home/stax/.bashrc
RUN echo 'cd /home/stax/repo' >> /home/stax/.bashrc

ENV ENV=/home/stax/.bashrc