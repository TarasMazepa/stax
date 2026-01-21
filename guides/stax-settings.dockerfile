FROM taras0mazepa/stax-guide-base:0.10.26

RUN <<EOF
touch LICENSE.md
git add LICENSE.md
git commit -m "Adds LICENSE.md"
git push

echo 'echo -e "\n===== stax settings demo =====\n"' > /home/stax/.bashrc
echo 'echo "This demo shows how to use stax settings command:"' >> /home/stax/.bashrc
echo 'echo -e "\n * branch_prefix - Prefix added to all new branch names (e.g., \"feature/\")"' >> /home/stax/.bashrc
echo 'echo " * default_branch - Override for default branch (empty means use <remote>/HEAD)"' >> /home/stax/.bashrc
echo 'echo " * default_remote - Override for default remote (empty means use first available)"' >> /home/stax/.bashrc
echo 'echo " * base_branch_replacement - Auto-substitute specific branch when creating PR"' >> /home/stax/.bashrc
echo 'echo " * additionally_pull - Additional branches to pull besides default_branch"' >> /home/stax/.bashrc
echo 'echo -e "\nCommands:"' >> /home/stax/.bashrc
echo 'echo " * stax settings set <name> <value> - Set a single value"' >> /home/stax/.bashrc
echo 'echo " * stax settings add <name> <value> - Add to a list setting"' >> /home/stax/.bashrc
echo 'echo " * stax settings remove <name> <value> - Remove from a list setting"' >> /home/stax/.bashrc
echo 'echo " * stax settings clear <name> - Clear a setting"' >> /home/stax/.bashrc
echo 'echo " * stax settings show - Show all settings"' >> /home/stax/.bashrc
echo 'echo -e "\nFlags:"' >> /home/stax/.bashrc
echo 'echo " -g, --global - Perform operation on global settings regardless of invocation path"' >> /home/stax/.bashrc
echo 'echo -e "\nTry setting branch_prefix: \"stax settings set branch_prefix feature/\"\n"' >> /home/stax/.bashrc
echo 'cd /home/stax/repo' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
