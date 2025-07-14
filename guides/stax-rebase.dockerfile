FROM taras0mazepa/stax-guide-base:0.10.12

RUN <<EOF
touch fix-button.txt
stax commit -ab "fix button"

touch fix-field.txt
stax commit -ab "fix field"

stax move head
touch README.md
git add README.md
git commit -m "Adds README.md"
git push

git checkout fix-button

echo 'echo -e "\n===== stax rebase demo =====\n"' > /home/stax/.bashrc
echo 'echo "This demo shows how to rebase branch trees."' >> /home/stax/.bashrc
echo 'echo "Run \"stax rebase\" to rebase fix-button onto updated main"' >> /home/stax/.bashrc
echo 'echo -e "Check \"stax log\" to see the updated history\n"' >> /home/stax/.bashrc
echo 'cd /home/stax/repo' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
