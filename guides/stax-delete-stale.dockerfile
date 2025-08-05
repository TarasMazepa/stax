FROM taras0mazepa/stax-guide-base:0.10.17

RUN <<EOF
touch login-page.txt
stax commit -ab "login page refactor"
touch button.txt
stax commit -ab "new button component"
touch registration.txt
stax commit -ab "registration form"
touch old-ui.txt
stax commit -ab "outdated ui design"
git checkout main

git checkout main
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

cd /home/stax/origin
git branch -D registration-form outdated-ui-design

echo 'echo -e "\n===== stax delete-stale demo =====\n"' > /home/stax/.bashrc
echo 'echo "This demo has following branches:"' >> /home/stax/.bashrc
echo 'echo " * login-page-refactor and new-button-component - branches with their remotes in tact"' >> /home/stax/.bashrc
echo 'echo " * registration-form and outdated-ui-design - branches whose remote counterparts were deleted (gone)"' >> /home/stax/.bashrc
echo 'echo -e "Run \"stax delete-stale\" to see and cleanup local branches. Try out \"-f\" flag too!\n"' >> /home/stax/.bashrc
cd /home/stax/repo
git fetch -p
EOF

ENV ENV=/home/stax/.bashrc
