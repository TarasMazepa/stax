# Stax

stax - manage git branches and stack PRs

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

Clone this repo and put the path to the repo into your PATH variable. You would need to have dart [installed](https://dart.dev/get-dart#install) on your system.

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

To see full list of commands, run:

```
stax help
```

Here is the list of commands currently available:

### stax commit

Creates branch, commits current changes with the same name as a branch, and pushes.

![stax commit diagram](https://github.com/TarasMazepa/stax/assets/6552358/013c5848-1697-49b2-a1b2-17f17eeea9cb)

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

You can see that a branch with `two-in-one-commit-name-and-branch-name` name was created as well as
a commit with the same name `two-in-one-commit-name-and-branch-name`.

### stax amend

Amends to the current commit and force pushes the branch

![stax amend diagram](https://github.com/TarasMazepa/stax/assets/6552358/c3025256-2e4f-4c8f-95c1-095ab9b8b514)

```
stax amend
```

### stax delete-stale

Deletes local branches with gone remotes. It is useful when you are using `stax-commit`, which pushes all
the branches. So once they are merged and deleted from the remote, you can clean up local branches.

![stax delete-stale diagram](https://github.com/TarasMazepa/stax/assets/6552358/55be3cf5-3667-4568-a8b0-785f623ec680)

### stax pull

Switching to the main branch, pulling all the changes, deleting gone branches, and switching to the original
branch.

![stax pull diagram](https://github.com/TarasMazepa/stax/assets/6552358/581b2384-2cce-4e78-9be2-76241e0f6c8e)

### stax log

Outputs tree structure of your branches.

```
> stax log
  x Updates-stax-log-example-in-readme
  o Adds-stax-log-example-to-readme
o-┘ origin/main, origin/HEAD, main
| o Promotes-version-command-to-be-not-hidden-command
o-┘
```

### stax rebase

Rebase tree of nodes on top of the <remote>/head or reference provided as first positional argument.

### stax move

Move has five directions:

* `up` — one node up. You can optionally specify the index of the child node (as represented in the log command); the
  default is 0.
* `down` — one node up
* `top` — to the topmost node, but stop on the first node with more than one child. Optionally you can specify an index
  of the child node (as represented in log command), default is 0.
* `bottom` — to the bottommost node, but stop on the first node that has more than one child, or stop before the node
  that had <remote>/head as a child.
* `head` — moves to the <remote>/head

# Videos

[Why stack pull request?](https://youtu.be/gJu0oseqaqs)

[Checking out stacking workflow](https://www.youtube.com/watch?v=zoqbYxW3saY)

## Alternatives (alphabetical order)

* https://ejoffe.github.io/spr/
* https://git-town.com/
* https://gitbutler.com/
* https://github.com/VirtusLab/git-machete
* https://github.com/arxanas/git-branchless
* https://github.com/ezyang/ghstack
* https://github.com/gitext-rs/git-stack
* https://github.com/jj-vcs/jj
* https://github.com/modularml/stack-pr
* https://graphite.dev/
* https://sapling-scm.com/
* https://stacked-git.github.io/
