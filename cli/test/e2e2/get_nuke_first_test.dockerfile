FROM stax-e2e-test:latest

RUN <<EOF
set -e
git config --global user.email stax@example.com
git config --global user.name stax
git config --global init.defaultBranch main
git init --bare /remote/repo.git
git clone /remote/repo.git /repo
cd /repo
echo tracked > tracked.txt
git add tracked.txt
git commit -m 'initial commit'
git push --set-upstream origin main
git switch --create feature
echo feature > feature.txt
git add feature.txt
git commit -m 'feature commit'
git push --set-upstream origin feature
git switch main
git remote set-head origin --auto
EOF

WORKDIR /repo
