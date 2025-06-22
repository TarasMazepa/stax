FROM taras0mazepa/stax-guide-base:0.10.8

RUN <<EOF
touch README.md
git add README.md
git commit -m "Initial commit"
git branch -M main
git push

git checkout main
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

touch login-page.txt
stax commit -ab "login page"

touch login-page-refactor.txt

echo 'echo -e "\n===== stax amend demo =====\n"' > /home/stax/.bashrc
echo 'echo "This demo shows how to use stax amend command:"' >> /home/stax/.bashrc
echo 'echo -e "\n * stax amend -A - adds tracked and untracked files in whole working tree before amending"' >> /home/stax/.bashrc
echo 'echo " * stax amend -a - adds tracked and untracked files in current folder before amending"' >> /home/stax/.bashrc
echo 'echo " * stax amend -u - adds only tracked files in whole working tree before amending"' >> /home/stax/.bashrc
echo 'echo " * stax amend -r - runs rebase afterwards on all children branches"' >> /home/stax/.bashrc
echo 'echo " * stax amend -m - runs rebase with prefer-moving afterwards on children"' >> /home/stax/.bashrc
echo 'echo " * stax amend -b - runs rebase with prefer-base afterwards on children"' >> /home/stax/.bashrc
echo 'echo -e "\nTry updating the changes by running \"stax amend -u\"\n"' >> /home/stax/.bashrc
echo 'cd /home/stax/repo' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
