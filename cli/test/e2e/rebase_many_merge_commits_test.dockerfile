FROM stax-e2e-test:latest

RUN <<EOF
set -e

git config --global user.email stax@example.com
git config --global user.name stax
git config --global init.defaultBranch main

git init --quiet --bare /origin

git clone --quiet /origin /repo
cd /repo
echo main > main.txt
echo side 0 > side.txt
git add .
git commit --quiet -m "initial commit"
git push --quiet --set-upstream origin main

# Stack of two branches rooted at the initial commit, so that a rebase onto the
# updated main actually has work to do.
git checkout --quiet -b feature-one
echo one > one.txt
git add .
git commit --quiet -m "feature one"
git push --quiet --set-upstream origin feature-one

git checkout --quiet -b feature-two
echo two > two.txt
git add .
git commit --quiet -m "feature two"
git push --quiet --set-upstream origin feature-two

# Grow main with a lot of merge commits. Every side branch rewrites the same
# file, so the merge back into main is always conflict free. Side branches are
# deleted right after they are merged, so the repository ends up with many merge
# commits rather than with many refs.
git checkout --quiet main
i=1
while [ "$i" -le 300 ]; do
  git checkout --quiet -b "side-$i" main
  echo "side $i" > side.txt
  git commit --quiet --all -m "side $i"
  git checkout --quiet main
  git merge --quiet --no-ff -m "merge side $i" "side-$i"
  git branch --quiet --delete "side-$i"
  i=$((i + 1))
done
git push --quiet origin main
git remote set-head origin --auto

git checkout --quiet feature-one

# Ground truth built with plain git, used to assert what stax rebase produced.
git clone --quiet /origin /repo-expected
cd /repo-expected
git checkout --quiet -b feature-one origin/feature-one
git rebase --quiet origin/main
git checkout --quiet -b feature-two origin/feature-two
git rebase --quiet --onto feature-one origin/feature-one
EOF

WORKDIR /repo
