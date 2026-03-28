FROM taras0mazepa/stax-guide-base:0.11.7

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

echo 'echo -e "\n===== stax rebase demo =====\n"' >> /home/stax/.bashrc
echo 'echo "This demo shows how to rebase branch trees."' >> /home/stax/.bashrc
echo 'echo -e "\nFlags:"' >> /home/stax/.bashrc
echo 'echo " * -a, --abandon       - Abandon rebase that is in progress"' >> /home/stax/.bashrc
echo 'echo " * -c, --continue      - Continue rebase that is in progress"' >> /home/stax/.bashrc
echo 'echo " * -b, --prefer-base   - Prefer base changes on conflict"' >> /home/stax/.bashrc
echo 'echo " * -m, --prefer-moving - Prefer moving changes on conflict"' >> /home/stax/.bashrc
echo 'echo -e "\nRun \"stax rebase\" to rebase fix-button onto updated main"' >> /home/stax/.bashrc
echo 'echo -e "Check \"stax log\" to see the updated history\n"' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
