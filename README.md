# Stax

## stax-commit
Creates branch, commits current changes with the same name as a branch and pushes.
```
stax-commit "two-in-one-commit-name-and-branch-name"
```
Result:
```
commit 8161c952fbed66672aff80cd3d1233589cdc3c0c (HEAD -> two-in-one-commit-name-and-branch-name, origin/two-in-one-commit-name-and-branch-name)
Author: Taras Mazepa <taras.mazepa@example.com>
Date:   Fri Sep 8 14:58:04 2023 -0700

    two-in-one-commit-name-and-branch-name

```

## stax-amend
Amends to the current commit and force pushes
```
stax-amend
```
