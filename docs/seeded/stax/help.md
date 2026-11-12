# Stax CLI Reference

Reference documentation generated from `stax help`.

## Global Flags

* `--accept-all`: Accept all user prompts automatically.
* `--decline-all`: Decline all user prompts automatically.
* `-h, --help`: Shows help documentation for the command.
* `--log`: Output log after finishing running requested command.
* `-q, --quiet`: Removes all output except user prompts.
* `-v, --verbose`: Force all the output.

## Commands

> [!NOTE]
> You can type the first letter or couple of first letters instead of the full command name (e.g., `c` for `commit`, `am` for `amend`).

### `amend`, `a`

Amends and pushes changes.

**Flags:**
* `-A, --add-workspace`: Runs `git add -A` before other actions. Adds tracked and untracked files across the whole working tree.
* `-a, --add-current`: Runs `git add .` before other actions. Adds tracked and untracked files in current folder and subfolders.
* `-b, --rebase-prefer-base`: Runs `stax rebase --prefer-base` afterwards on all children branches.
* `-g, --get-first`: Runs `git stash ; stax get --current ; git stash pop` before performing amend sequence.
* `-m, --rebase-prefer-moving`: Runs `stax rebase --prefer-moving` afterwards on all children branches.
* `-r, --rebase`: Runs `stax rebase` afterwards on all children branches.
* `--skip-rebase`: Skip asking for rebase entirely.
* `-u, --update-tracked`: Runs `git add -u` before other actions. Adds only tracked files across the whole working tree.

### `commit`

Creates a branch, commits, and pushes it to remote. First argument is mandatory commit message. Second argument is optional branch name; if not provided, the branch name is generated from the commit message.

**Positional arguments:**
* `arg1`: Required commit message, usually enclosed in double quotes (e.g., `"Sample commit message"`).
* `opt2`: Optional branch name; if not provided, commit message will be converted to branch name.

**Flags:**
* `-A, --add-workspace`: Runs `git add -A` before other actions. Adds tracked and untracked files in whole working tree.
* `-a, --add-current`: Runs `git add .` before other actions. Adds tracked and untracked files in current folder and subfolders.
* `-b, --branch-from-commit`: Accepts branch name proposed by converting commit name to branch name.
* `-c, --come-back`: Moves back to the branch on which user was before running commit.
* `-d, --draft`: Creates a PR in draft mode using the GitHub CLI. Works only if you have GitHub as your remote.
* `-i, --ignore-no-staged-changes`: Skips check if there are staged changes; helpful when your change is only a rename of a file which stax cannot see at the moment.
* `-k, --cookie`: Add an optional string to the branch name after the prefix.
* `-n, --no-browser`: Do not attempt to open the PR URL in the browser.
* `-p, --pull-request`: Opens PR creation page on your remote. Works only if you have GitHub as your remote.
* `-u, --update-tracked`: Runs `git add -u` before other actions. Adds only tracked files across the whole working tree.

### `delete-stale`, `d`

Deletes local branches with gone remotes.

**Flags:**
* `-f, --force-delete`: Force delete gone branches.
* `-s, --skip-delete`: Skip deletion of gone branches.

### `get`

(Re)Checkout specified branch and all its children.

**Positional arguments:**
* `opt1`: Name of the remote ref. Will be matched as a suffix.

**Flags:**
* `-b, --rebase-prefer-base`: Runs `stax rebase --prefer-base` afterwards starting from the requested branch, rebasing all branches that depend on it.
* `-c, --current`: Force get current branch, skipping the confirmation prompt.
* `-m, --rebase-prefer-moving`: Runs `stax rebase --prefer-moving` afterwards starting from the requested branch, rebasing all branches that depend on it.
* `-n, --nuke-first`: Runs `stax extras nuke` before getting, resetting working directory and index to HEAD and cleaning all untracked files.
* `-r, --rebase`: Runs `stax rebase` afterwards starting from the requested branch, rebasing all branches that depend on it.
* `-s, --skip-pull`: Skip pulling new changes before getting.

### `help`

List of available commands.

**Positional arguments:**
* `opt1`: Optional name of the command you want to learn about.

**Flags:**
* `-a, --show-all`: Show all commands including hidden.

### `log`

Shows a tree of all branches.

**Flags:**
* `-a, --all-branches`: Show remote branches also.
* `-d, --default-branch`: Assume different default branch.

### `move`

Allows you to move around log tree.
Type any amount of first letters to specify direction: `h` for `head`, `t` for `top`, `d` for `down`, `u` for `up`, `b` for `bottom`, `l` for `left`, `r` for `right`.

**Positional arguments:**
* `[arg]+`: `up` (one up, optional 0-based child index), `down` (one down), `left` (previous sibling node), `right` (next sibling node), `top` (to closest top parent that has at least two children or to the top-most node; optional 0-based child index), `bottom` (to closest bottom parent that has at least two children or bottom-most node; stops before direct parent of `<remote>/head`), `head` (`<remote>/head`).

### `pull`, `p`

Switch to main branch, pull all changes, delete gone branches, and switch back to original branch.

**Positional arguments:**
* `opt1`: Optional target branch (defaults to `<remote>/HEAD`).

**Flags:**
* `-f, --force-delete`: Force delete gone branches.
* `-n, --no-switch-back`: Stay on the head/default branch after pulling.
* `-s, --skip-delete`: Skip deletion of gone branches.

### `pull-request`, `pr`

Creates a pull request.

### `rebase`

Rebase tree of branches on top of main.

**Positional arguments:**
* `opt1`: Optional argument for target (defaults to `<remote>/HEAD`).

**Flags:**
* `-a, --abandon`: Abandon rebase that is in progress.
* `-b, --prefer-base`: Prefer base changes on conflict.
* `-c, --continue`: Continue rebase that is in progress.
* `-m, --prefer-moving`: Prefer moving changes on conflict.

### `extras`, `e`

Extra non-primary commands (`about`, `agents.md`, `changelog`, `doctor`, `nuke`, `settings`, `update`, `version`). Run `stax extras` to see detailed list.

**Positional arguments:**
* `arg1`: Subcommand to run (`about`, `agents.md`, `changelog`, `doctor`, `nuke`, `settings`, `update`, `version`).
