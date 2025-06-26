FROM taras0mazepa/stax-guide-base:0.10.10

RUN <<EOF
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

git checkout -b login-feature
touch login-page.txt
git add login-page.txt
git commit -m "Add login page"
git push -u origin login-feature

git checkout -b remember-password-feature
touch remember-password.txt
git add remember-password.txt
git commit -m "Add remember password functionality"
git push -u origin remember-password-feature

git checkout -b registration-feature
touch registration.txt
git add registration.txt
git commit -m "Add registration form"
git push -u origin registration-feature

git checkout -b ui-feature
touch ui-update.txt
git add ui-update.txt
git commit -m "Update UI design"
git push -u origin ui-feature

git checkout -b dark-theme-feature
touch dark-theme.txt
git add dark-theme.txt
git commit -m "Add dark theme support"
git push -u origin dark-theme-feature

mkdir -p /home/stax/second-repo
cd /home/stax/second-repo
git clone /home/stax/origin .

touch login-page.txt
git add login-page.txt
git commit -m "login page"
git push

git checkout login-feature
echo "Added login validation" >> login-page.txt
git add login-page.txt
git commit -m "Add login validation"
git push

git checkout remember-password-feature
echo "Added password encryption" >> remember-password.txt
git add remember-password.txt && git commit -m "Add password encryption" && git push

git checkout registration-feature
echo "Added email validation" >> registration.txt
git add registration.txt && git commit -m "Add email validation" && git push

git checkout ui-feature
echo "Updated button styles" >> ui-update.txt
git add ui-update.txt && git commit -m "Update button styles" && git push

git checkout dark-theme-feature
echo "Added theme switcher" >> dark-theme.txt
git add dark-theme.txt && git commit -m "Add theme switcher" && git push

cd /home/stax/repo
git fetch

echo 'echo -e "\n===== stax get demo =====\n"' > /home/stax/.bashrc
echo 'echo "This demo shows how to use stax get command:"' >> /home/stax/.bashrc
echo 'echo -e "\nstax get <branch-name> - (Re)Checkout specified branch and all its children && pull latest changes"' >> /home/stax/.bashrc
echo 'echo " * The branch name will be matched as a suffix"' >> /home/stax/.bashrc
echo 'echo " * For example: stax get main - will checkout main branch"' >> /home/stax/.bashrc
echo 'echo " * For example: stax get feature - will checkout any branch ending with feature"' >> /home/stax/.bashrc
echo 'echo -e "\nTry checking out the main branch by running \"stax get main\"\n"' >> /home/stax/.bashrc
echo 'cd /home/stax/repo' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
