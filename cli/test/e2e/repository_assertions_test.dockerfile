FROM stax-e2e-test:latest

RUN apk add --no-cache diffutils

RUN <<EOF
set -e

git config --global user.email stax@example.com
git config --global user.name stax
git config --global init.defaultBranch main

mkdir -p /repo/dir
cd /repo
git init --quiet
echo alpha > a.txt
echo beta > dir/b.txt
git add .
git commit --quiet -m "first commit"
echo gamma >> a.txt
git commit --quiet --all -m "second commit"

git clone --quiet /repo /repo-same
git clone --quiet /repo /repo-dirty
git clone --quiet /repo /repo-ahead

cd /repo-dirty
echo dirty >> a.txt
echo untracked > untracked.txt

cd /repo-ahead
echo delta > c.txt
git add .
git commit --quiet -m "third commit"
EOF
