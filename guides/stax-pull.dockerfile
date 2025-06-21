FROM taras0mazepa/stax-guide-base:0.10.7

RUN <<EOF
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

mkdir -p /home/stax/second-repo
cd /home/stax/second-repo
git clone /home/stax/origin .

touch login-page.txt
git add login-page.txt
git commit -m "login page"
git push

touch remember-password.txt
git add remember-password.txt
git commit -m "remember password"
git push

cd /home/stax/repo

touch registration.txt
stax commit -ab "registration form not working"
touch old-ui.txt
stax commit -ab "outdated ui design"
touch ui-update.txt
stax commit -ab "ui update"

cd /home/stax/origin
git branch -D registration-form-not-working outdated-ui-design

cd /home/stax/repo
git fetch

echo 'echo -e "\n===== stax pull demo =====\n"' > /home/stax/.bashrc
echo 'echo "This demo shows how to update your local repository:"' >> /home/stax/.bashrc
echo 'echo -e "\n * Run \"stax pull\" to switch to remote HEAD, pull latest changes, and return to your branch"' >> /home/stax/.bashrc
echo 'echo " * Use \"stax pull -f\" to force delete gone branches"' >> /home/stax/.bashrc
echo 'echo " * Use \"stax pull -s\" to skip deletion of gone branches"' >> /home/stax/.bashrc
echo 'echo " * Optionally specify a target branch, e.g. \"stax pull origin/main\""' >> /home/stax/.bashrc
echo 'echo -e "\nTry running \"git branch -vv\" before and after to see the changes!\n"' >> /home/stax/.bashrc
echo 'cd /home/stax/repo' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
