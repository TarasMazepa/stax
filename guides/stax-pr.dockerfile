FROM taras0mazepa/stax-guide-base:0.11.7

RUN <<EOF
touch file.txt
stax commit -ab "my changes"

echo 'echo -e "\n===== stax pr demo =====\n"' >> /home/stax/.bashrc
echo 'echo "This demo shows how to create a PR:"' >> /home/stax/.bashrc
echo 'echo -e "\n * stax pr - Creates a pull request for the current branch"' >> /home/stax/.bashrc
echo 'echo -e "\nTry running \"stax pr\"\n"' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
