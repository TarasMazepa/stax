FROM taras0mazepa/stax-guide-base:0.10.10

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

echo 'echo -e "\n===== stax log demo =====\n"' > /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
