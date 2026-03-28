FROM taras0mazepa/stax:0.11.7

RUN <<EOF
mkdir -p /home/stax/origin /home/stax/repo /home/stax/setup

git config --global user.email "stax@staxforgit.com"
git config --global user.name "stax"
git config --global init.defaultBranch main
git config --global push.autoSetupRemote true

cd /home/stax/origin
git init --bare

cd /home/stax/setup
git clone /home/stax/origin .
touch CONTRIBUTORS.md
git add CONTRIBUTORS.md
git commit -m "Initial commit"
git push

cd /home/stax/repo
rm -rf /home/stax/setup
git clone /home/stax/origin .

echo "export PS1='\033[01;32m\w\033[00m \033[01;36m\$(git branch --show-current 2>/dev/null)\033[00m $ '" > /home/stax/.bashrc
EOF

WORKDIR /home/stax/repo
