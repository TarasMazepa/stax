FROM taras0mazepa/stax-guide-base:0.11.7

RUN <<EOF
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

touch fix-button.txt

mkdir -p /usr/local/bin
echo '#!/bin/bash' > /usr/local/bin/open
echo 'echo "===== BROWSER SIMULATION ====="' >> /usr/local/bin/open
echo 'echo "Opening URL: $1"' >> /usr/local/bin/open
echo 'echo "This would open a browser to create a pull request in a real environment."' >> /usr/local/bin/open
echo 'echo "============================"' >> /usr/local/bin/open

echo 'echo -e "\n===== stax commit demo =====\n"' >> /home/stax/.bashrc
echo 'echo "This demo shows how to use stax commit command:"' >> /home/stax/.bashrc
echo 'echo -e "\nUsage: stax commit \"commit message\" [branch name]"' >> /home/stax/.bashrc
echo 'echo -e "\nThe commit message is required and should be in quotes, like: \"Fix button styling\""' >> /home/stax/.bashrc
echo 'echo "The branch name is optional - if not provided, it will be generated from the commit message"' >> /home/stax/.bashrc
echo 'echo -e "\nFlags:"' >> /home/stax/.bashrc
echo 'echo " * -A     - Add all tracked and untracked files in entire working tree"' >> /home/stax/.bashrc
echo 'echo " * -a     - Add all tracked and untracked files in current folder and subfolders"' >> /home/stax/.bashrc
echo 'echo " * -u     - Add only tracked files in entire working tree"' >> /home/stax/.bashrc
echo 'echo " * -b     - Accept branch name generated from commit message"' >> /home/stax/.bashrc
echo 'echo " * -c     - Move back to the branch you were on before running commit"' >> /home/stax/.bashrc
echo 'echo " * -d     - Create a PR in draft mode using the GitHub CLI"' >> /home/stax/.bashrc
echo 'echo " * -i     - Skip check for staged changes (useful for renames)"' >> /home/stax/.bashrc
echo 'echo " * -k     - Add an optional string to the branch name after the prefix"' >> /home/stax/.bashrc
echo 'echo " * -n     - Do not attempt to open the PR URL in the browser"' >> /home/stax/.bashrc
echo 'echo " * -p     - Create and open PR after pushing (GitHub only)"' >> /home/stax/.bashrc
echo 'echo -e "\nExample: stax commit -a \"Fix button styling\" button-fix\n"' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
