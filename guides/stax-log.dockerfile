FROM taras0mazepa/stax-guide-base:0.11.7

RUN <<EOF
touch auth.md
stax c -ab "feature auth"

touch auth.js
stax c -ab "feature password reset"

git checkout main
touch ui.md
stax c -ab "feature ui"

touch styles.css
stax c -ab "feature dark theme"

git checkout feature-ui
touch styles.css
stax c -ab "feature responsive"

git checkout main
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

echo 'echo -e "\n===== stax log demo =====\n"' >> /home/stax/.bashrc
echo 'echo "This demo shows how to view your branch tree."' >> /home/stax/.bashrc
echo 'echo -e "\n * Run \"stax log\" to see the local branch tree"' >> /home/stax/.bashrc
echo 'echo " * Run \"stax log -a\" to see local and remote branches"' >> /home/stax/.bashrc
echo 'echo -e "\nTry running \"stax log -a\"\n"' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
