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

To see full list of commands, run:

```
stax help
```

Here is the list of commands currently available:

```
Global flags:
   --accept-all - Accept all the user prompts automatically.
   --decline-all - Decline all the user prompts automatically.
   -h, --help - Shows help documentation for the command
   -q, --quiet - Removes all output except user prompts.
   -v, --verbose - Force all the output.
Here are available commands:
Note: you can type first letter or couple of first letters instead of full command name. 'c' for 'commit' or 'am' for 'amend'.
 • amend, a - Amends and pushes changes.
      Flags:
         -A - Runs 'git add -A' before other actions. Which adds tracked and untracked files in whole working tree.
         -a - Runs 'git add .' before other actions. Which adds tracked and untracked files in current folder and subfolders.
         -b, --rebase-prefer-base - Runs 'stax rebase --prefer-base' afterwards on all children branches.
         -m, --rebase-prefer-moving - Runs 'stax rebase --prefer-moving' afterwards on all children branches.
         -r, --rebase - Runs 'stax rebase' afterwards on all children branches.
         -u - Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.
 • commit - Creates a branch, commits, and pushes it to remote. First argument is mandatory commit message. Second argument is optional branch name, if not provided branch name would be generated from commit message.
      Positional arguments:
         arg1 - Required commit message, usually enclosed in double quotes like this: "Sample commit message".
         opt2 - Optional branch name, if not provided commit message would be converted to branch name.
      Flags:
         -A - Runs 'git add -A' before other actions. Which adds tracked and untracked files in whole working tree.
         -a - Runs 'git add .' before other actions. Which adds tracked and untracked files in current folder and subfolders.
         -b, --branch-from-commit - Accepts branch name proposed by converting commit name to branch name.
         -d, --draft - Creates a PR in draft mode using the GitHub CLI. Works only if you have GitHub as your remote.
         -i, --ignore-no-staged-changes - Skips check if there staged changes, helpful when your change is only rename of the file which stax can't see at the moment.
         -p, --pull-request - Opens PR creation page on your remote. Works only if you have GitHub as your remote.
         -u - Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.
 • delete-stale, d - Deletes local branches with gone remotes.
      Flags:
         -f, --force-delete - Force delete gone branches.
         -s, --skip-delete - Skip deletion of gone branches.
 • extras, e - Extra non-primary commands (about, changelog, doctor, help, settings, update, version). Run `stax extras` to see detailed list.
      Positional arguments:
         arg1 - Subcommand to run
 • get - (Re)Checkout specified branch and all its children
      Positional arguments:
         opt1 - Name of the remote ref. Will be matched as a suffix.
      Flags:
         -b, --rebase-prefer-base - Runs 'stax rebase --prefer-base' afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.
         -c, --current - Force get current branch, skipping the confirmation prompt.
         -m, --rebase-prefer-moving - Runs 'stax rebase --prefer-moving' afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.
         -r, --rebase - Runs 'stax rebase' afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.
 • log - Shows a tree of all branches.
      Flags:
         -a, --all-branches - show remote branches also
         -d, --default-branch - assume different default branch
 • move - Allows you to move around log tree. Note: you can type any amount of first letters to specify direction. 'h' instead of 'head', 't' for 'top, 'd' for down, 'u' for 'up', 'b' for 'bottom', 'l' for 'left', 'r' for 'right'
      Positional arguments:
         [arg]+ - up (one up, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), down (one down), left (previous sibling node), right (next sibling node), top (to the closest top parent that have at least two children or to the top most node, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), bottom (to the closest bottom parent that have at least two children or bottom most node, will stop before any direct parent of <remote>/head), head (<remote>/head)
 • pull, p - Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.
      Positional arguments:
         opt1 - Optional target branch, will default to <remote>/HEAD
      Flags:
         -f, --force-delete - Force delete gone branches.
         -s, --skip-delete - Skip deletion of gone branches.
 • pull-request, pr - Creates a pull request.
 • rebase - rebase tree of branches on top of main
      Positional arguments:
         opt1 - Optional argument for target, will default to <remote>/HEAD
      Flags:
         -a, --abandon - Abandon rebase that is in progress, stax can't abort own rebases.
         -b, --prefer-base - Prefer base changes on conflict.
         -c, --continue - Continue rebase that is in progress.
         -m, --prefer-moving - Prefer moving changes on conflict.
```

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
