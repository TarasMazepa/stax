# Stax

stax - manage git branches and stack PRs

[Are you new to Git? Check out our Stax Onboarding Guide for Beginners!](guides/onboarding.md)

## Installation

### MacOS

[Homebrew](https://brew.sh/) is a package manager for MacOS.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install stax

```shell
brew install TarasMazepa/stax/stax
```

### Windows

[Chocolatey](https://chocolatey.org/) is a package manager for Windows.

Follow [this guide](https://docs.chocolatey.org/en-us/choco/setup/) to install chocolatey.

Install stax

```powershell
choco install stax
```

### Linux/WSL on Windows/ChromeOS

Homebrew is a package manager for MacOS that also [works on Linux systems](https://docs.brew.sh/Homebrew-on-Linux).

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install stax

```shell
brew install TarasMazepa/stax/stax
```

### Alternative

Clone this repo and put the path to the repo's `path` folder into your PATH variable. You would need to have dart [installed](https://dart.dev/get-dart#install) on your system.

## stax doctor

Will help you to set up everything that stax needs to start working

```
stax doctor
```

```
[V] git config --get user.name # Taras Mazepa
[V] git config --get user.email # 6552358+TarasMazepa@users.noreply.github.com
[V] git config --get push.autoSetupRemote # true
[V] git remote # remote(s): origin
[V] git rev-parse --abbrev-ref origin/HEAD # main
```

## Commands

To see the full list of commands, run:

```shell
stax help
```

Here is the list of commands currently available. Note: you can type the first letter or couple of letters instead of the full command name (e.g., `c` for `commit`, `am` for `amend`).

### `stax commit` (alias: `c`)
Creates a branch, commits current changes with the same name as the branch, and pushes it to remote. First argument is the mandatory commit message. Second argument is an optional branch name; if not provided, the branch name is generated from the commit message.

**Positional arguments:**
* `arg1`: Required commit message, usually enclosed in double quotes (e.g., `"Sample commit message"`).
* `opt2`: Optional branch name.

**Flags:**
* `-A`: Runs `git add -A` before other actions. Which adds tracked and untracked files in the whole working tree.
* `-a`: Runs `git add .` before other actions. Which adds tracked and untracked files in the current folder and subfolders.
* `-b, --branch-from-commit`: Accepts the branch name proposed by converting the commit name to the branch name.
* `-d, --draft`: Creates a PR in draft mode using the GitHub CLI. Works only if you have GitHub as your remote.
* `-i, --ignore-no-staged-changes`: Skips checking for staged changes, helpful when your change is only a rename of the file which stax can't see at the moment.
* `-p, --pull-request`: Opens the PR creation page on your remote. Works only if you have GitHub as your remote.
* `-u`: Runs `git add -u` before other actions. Which adds only tracked files in the whole working tree.


```shell
stax commit "two-in-one-commit-name-and-branch-name"
```
**Result:**
```
commit 8161c952fbed66672aff80cd3d1233589cdc3c0c (HEAD -> two-in-one-commit-name-and-branch-name, origin/two-in-one-commit-name-and-branch-name)
Author: Taras Mazepa <taras.mazepa@example.com>
Date:   Fri Sep 8 14:58:04 2023 -0700

    two-in-one-commit-name-and-branch-name
```
You can see that a branch with `two-in-one-commit-name-and-branch-name` name was created as well as a commit with the same name `two-in-one-commit-name-and-branch-name`.

---

### `stax amend` (alias: `a`)
Amends to the current commit and force pushes the branch.

**Flags:**
* `-A`: Runs `git add -A` before other actions.
* `-a`: Runs `git add .` before other actions.
* `-b, --rebase-prefer-base`: Runs `stax rebase --prefer-base` afterwards on all children branches.
* `-m, --rebase-prefer-moving`: Runs `stax rebase --prefer-moving` afterwards on all children branches.
* `-r, --rebase`: Runs `stax rebase` afterwards on all children branches.
* `-u`: Runs `git add -u` before other actions.


```shell
stax amend
```

---

### `stax delete-stale` (alias: `d`)
Deletes local branches with gone remotes. It is useful when you are using `stax commit`, which pushes all the branches. So once they are merged and deleted from the remote, you can clean up local branches.

**Flags:**
* `-f, --force-delete`: Force delete gone branches.
* `-s, --skip-delete`: Skip deletion of gone branches.


---

### `stax pull` (alias: `p`)
Switching to the main branch, pulling all the changes, deleting gone branches, and switching to the original branch.

**Positional arguments:**
* `opt1`: Optional target branch, will default to `<remote>/HEAD`.

**Flags:**
* `-f, --force-delete`: Force delete gone branches.
* `-s, --skip-delete`: Skip deletion of gone branches.


---

### `stax log`
Outputs tree structure of your branches.

**Flags:**
* `-a, --all-branches`: Show remote branches also.
* `-d, --default-branch`: Assume different default branch.

```shell
> stax log
  x Updates-stax-log-example-in-readme
  o Adds-stax-log-example-to-readme
o-┘ origin/main, origin/HEAD, main
| o Promotes-version-command-to-be-not-hidden-command
o-┘
```

---

### `stax rebase`
Rebase tree of branches on top of the main branch.

**Positional arguments:**
* `opt1`: Optional argument for target, will default to `<remote>/HEAD`.

**Flags:**
* `-a, --abandon`: Abandon rebase that is in progress, stax can't abort own rebases.
* `-b, --prefer-base`: Prefer base changes on conflict.
* `-c, --continue`: Continue rebase that is in progress.
* `-m, --prefer-moving`: Prefer moving changes on conflict.

---

### `stax move`
Allows you to move around log tree. Note: you can type any amount of first letters to specify direction. 'h' instead of 'head', 't' for 'top, 'd' for down, 'u' for 'up', 'b' for 'bottom', 'l' for 'left', 'r' for 'right'.

**Directions:**
* `up`: One node up. You can optionally specify the index of the child node (as represented in the log command); the default is 0.
* `down`: One node down.
* `left`: Previous sibling node.
* `right`: Next sibling node.
* `top`: To the closest top parent that has at least two children or to the topmost node. Optionally you can specify an index of the child node (as represented in log command), default is 0.
* `bottom`: To the closest bottom parent that has at least two children or bottommost node, will stop before any direct parent of `<remote>/HEAD`.
* `head`: Moves to the `<remote>/HEAD`.

---

### `stax get`
(Re)Checkout specified branch and all its children.

**Positional arguments:**
* `opt1`: Name of the remote ref. Will be matched as a suffix.

**Flags:**
* `-b, --rebase-prefer-base`: Runs `stax rebase --prefer-base` afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.
* `-c, --current`: Force get current branch, skipping the confirmation prompt.
* `-m, --rebase-prefer-moving`: Runs `stax rebase --prefer-moving` afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.
* `-r, --rebase`: Runs `stax rebase` afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.

---

### `stax pull-request` (alias: `pr`)
Creates a pull request.

---

### `stax extras` (alias: `e`)
Extra non-primary commands (`about`, `changelog`, `doctor`, `help`, `settings`, `update`, `version`). Run `stax extras` to see detailed list.

**Positional arguments:**
* `arg1`: Subcommand to run.

---

### Global Flags
These flags apply globally to most commands:
* `--accept-all`: Accept all the user prompts automatically.
* `--decline-all`: Decline all the user prompts automatically.
* `-h, --help`: Shows help documentation for the command.
* `-q, --quiet`: Removes all output except user prompts.
* `-v, --verbose`: Force all the output.

# Videos

[Why stack pull request?](https://youtu.be/gJu0oseqaqs)

[Checking out stacking workflow](https://www.youtube.com/watch?v=zoqbYxW3saY)

## Alternatives (alphabetical order)

* https://github.com/VirtusLab/git-machete
* https://github.com/arxanas/git-branchless
* https://github.com/ejoffe/spr
* https://github.com/ezyang/ghstack
* https://github.com/facebook/sapling
* https://github.com/git-town/git-town
* https://github.com/gitbutlerapp/gitbutler
* https://github.com/gitext-rs/git-stack
* https://github.com/iOliverNguyen/git-pr
* https://github.com/jj-vcs/jj
* https://github.com/modularml/stack-pr
* https://github.com/stacked-git/stgit
* https://github.com/torbiak/git-autofixup
* https://github.com/tummychow/git-absorb
* https://graphite.dev/
