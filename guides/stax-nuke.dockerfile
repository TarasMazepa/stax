FROM taras0mazepa/stax-guide-base:0.11.7

RUN <<EOF
touch tracked.txt
git add tracked.txt
git commit -m "add tracked"

echo "modified" > tracked.txt
touch untracked.txt

echo 'echo -e "\n===== stax nuke demo =====\n"' >> /home/stax/.bashrc
echo 'echo "This demo shows how to reset your workspace:"' >> /home/stax/.bashrc
echo 'echo -e "\n * stax extras nuke - Hard resets working directory and cleans all untracked files"' >> /home/stax/.bashrc
echo 'echo -e "\nTry running \"git status\" then \"stax extras nuke\" then \"git status\" again\n"' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
