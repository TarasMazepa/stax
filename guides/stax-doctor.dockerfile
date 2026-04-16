FROM taras0mazepa/stax-guide-base:0.11.7

RUN <<EOF
git config --global --unset user.name || true
git config --global --unset user.email || true
git config --global --unset push.autoSetupRemote || true

echo 'echo -e "\n===== stax doctor demo =====\n"' >> /home/stax/.bashrc
echo 'echo "This demo shows how stax doctor helps you set up."' >> /home/stax/.bashrc
echo 'echo -e "\nWe have unset some git config variables for this demo."' >> /home/stax/.bashrc
echo 'echo -e "Run \"stax extras doctor\" to identify and fix missing configuration.\n"' >> /home/stax/.bashrc
EOF

ENV ENV=/home/stax/.bashrc
