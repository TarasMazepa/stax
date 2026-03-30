# Stax Workflows Guide

This guide covers common and advanced Stax workflows to help you boost your productivity and manage your Git branches more effectively. It highlights how different command flags can be combined to achieve exactly what you need in a single line.

## Creating Pull Requests

When you are ready to share your work, Stax makes it incredibly simple to create a commit, branch, and open a PR.

*   `stax c -ubp "commit message"`: **Update, Branch, Push, PR Page**
    *   Adds updated files (`-u`), accepts the branch name automatically from your message (`-b`), opens the PR web page automatically on GitHub (`-p`). Perfect for quickly publishing a finished feature.
*   `stax c -abdn "commit message"`: **Add All, Branch, Draft PR, No Browser**
    *   Adds all files including untracked (`-a`), accepts the branch name automatically (`-b`), creates a PR in draft mode via GitHub CLI (`-d`), and does not attempt to open it in a browser (`-n`). Ideal for saving early work-in-progress to the remote.
*   `stax c -abdc "commit message"`: **Add All, Branch, Draft PR, Come Back**
    *   Adds all files (`-a`), accepts the branch name automatically (`-b`), creates a draft PR (`-d`), and instantly switches back to the previous branch you were on (`-c`). extremely useful when working on multiple parallel PRs and you just need to stash and save the current one.

## Syncing & Getting Latest Changes

Keeping your local environment up to date with your team or downloading specific remote branches is simplified with Stax.

*   `stax p -f`: **Pull and Clean Up**
    *   Switches to the default repository branch, pulls the latest changes, forcefully deletes local branches that have gone from the remote (`-f`), and switches back to your original branch.
*   `stax p -fn`: **Pull, Clean Up, and Stay**
    *   Same as above but stays on the default branch (`-n`) after pulling instead of switching back.
*   `stax g <branch name>`: **Get Branch**
    *   Forcefully fetches the remote branch, discarding any local changes you might have had on that branch.
*   `stax g -c`: **Get Current Branch**
    *   Forcefully fetches the remote counterpart of your *current* branch, discarding local changes. Great for resetting your branch to its remote state.
*   `stax g <branch name> -m`: **Get and Rebase**
    *   Forcefully fetches the remote branch, then rebases it on top of the default branch and rebases all of its child branches (`-m`, prefer moving changes).

## Amending and Updating Branches

When you need to fix a typo or add a forgotten file to your current work, `stax amend` is your best friend.

*   `stax a -ua` or `stax a -u -a`: **Amend Changes**
    *   Amends the current commit with updated (`-u`) or all (`-a`) files, then offers to rebase any child branches that depend on this one.
*   `stax a -am`: **Amend and Rebase**
    *   Amends with all files (`-a`) and automatically performs a rebase of all child branches using the prefer-moving strategy (`-m`).
*   `stax a -amg`: **Sync, Amend, and Rebase**
    *   Runs `stax g -c` first to force fetch the current branch from the remote, performs the amend (`-a`), and automatically rebases child branches (`-m`). This is especially useful when there are multiple concurrent changes happening to the branch (e.g., a colleague pushed a fix, or a CI system automatically formatted the code).

## Navigating the Tree

*   `stax m u`: Move one node up in the branch tree.
*   `stax m d`: Move one node down.
*   `stax m l` / `stax m r`: Move to sibling branches (left/right).
*   `stax m h`: Jump straight to the `head` (default) branch.
