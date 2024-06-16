# Stax

Stax is a tool that will help you a bit with day-to-day stax-like git workflow.

Main purpose is to make it easier to create smaller PRs. And reduce amount of energy other people need to review them.

## Installation

### MacOS/Linux/WSL on Windows/ChromeOS

#### Install brew

##### MacOS

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

##### Linux/WSL on Windows

See https://docs.brew.sh/Homebrew-on-Linux

#### Install stax

```
brew install TarasMazepa/stax/stax
```

### Windows

Clone this repo and put path to the repo into your PATH variable.

Let me know if you need some help, create a ticket on the repo.

## v1 Roadmap

| Feature                                            | Status |
|----------------------------------------------------|--------|
| [commit](#stax-commit)                             | ✅      |
| [amend](#stax-amend)                               | ✅      |
| [delete-gone-branches](#stax-delete-gone-branches) | ✅      |
| [pull](#stax-pull)                                 | ✅      |
| [log](#stax-log)                                   | 🚧     |
| rebase                                             | 🔲     |

## v2

Would be an UI tool that will implement all features from v1.

## What is stax-like git workflow?

It is a way to reduce the burden of creating commits, branches, and PRs, so it doesn't consume much of your time. As a result, you can start creating more PRs with smaller changes in them and have them reviewed easier and faster at the same time catching more bugs.

## Commands

To see full list of commands, run:
```
stax help
```

Here is the list of commands currently available:

### stax commit
Creates branch, commits current changes with the same name as a branch, and pushes.
```
stax commit "two-in-one-commit-name-and-branch-name"
```
Result:
```
commit 8161c952fbed66672aff80cd3d1233589cdc3c0c (HEAD -> two-in-one-commit-name-and-branch-name, origin/two-in-one-commit-name-and-branch-name)
Author: Taras Mazepa <taras.mazepa@example.com>
Date:   Fri Sep 8 14:58:04 2023 -0700

    two-in-one-commit-name-and-branch-name

```
You can see that a branch with `two-in-one-commit-name-and-branch-name` name was created as well as a commit with the same name `two-in-one-commit-name-and-branch-name`.

#### -a flag
Adds all the files to staging area

#### --pr flag
Redirects you to a create PR page

### stax amend
Amends to the current commit and force pushes branch
```
stax amend
```

### stax delete-gone-branches
Deletes local branches with gone remotes. Useful when you are using `stax-commit` which pushes all the branches. So once they are merged and deleted from the remote you can clean up local branches.

### stax pull
Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.

### stax log
Outputs tree like structure of your branches
