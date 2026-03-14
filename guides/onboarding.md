# Stax Onboarding Guide for Beginners

Welcome to Stax! If you use Git but find it confusing or overwhelming, this guide is for you. Stax is built to simplify your workflow, automating the most complex parts of Git so you can focus on writing code instead of struggling with branching and pushing.

## Setup

First time using Stax? We have commands to help you get started easily.

*   `stax doctor` : Helps you configure everything Stax needs for the first time, including optional setup steps.
*   `stax settings` : Allows you to configure Stax for your environment. For example, you can set `branch_prefix` to automatically add a prefix to your branch names.

## The Core Concept

In standard Git, saving and sharing your code requires a multi-step dance: making a branch, adding your files, committing with a message, and pushing to a remote repository while setting an upstream tracking branch.

**With Stax, you just tell it what your change is about, and it handles the rest.** You make your changes, you tell Stax to save them (commit), and it takes care of the complicated background work.

## Highlighting Simplicity: Stax vs. Regular Git

Let's look at how much simpler Stax makes your day-to-day work compared to regular Git. Stax also provides shorthand aliases (like `c` for `commit`) to save you even more typing!

### Saving and Uploading Your Work

**Regular Git:**
```shell
git checkout -b your-branch-name
git add -u # add updated files
git commit -m "your message"
git push -u origin your-branch-name
```

**With Stax:**
```shell
stax c -u "your message"
```
*That's it!* Stax automatically creates a branch, stages your updated files (`-u`), commits them, and pushes them to your remote repository.

### Updating Your Current Work

If you missed a file, made a typo, or received feedback and need to update your current branch:

**Regular Git:**
```shell
git add -u # add updated files
git commit --amend --no-edit
git push --force-with-lease
```

**With Stax:**
```shell
stax a -u
```
Stax adds your new updated changes (`-u`) to the existing commit and safely force-pushes the update.

### Getting the Latest Changes from Your Team

**Regular Git:**
```shell
git checkout main
git pull
git checkout your-branch-name
# You might also need to delete merged branches manually!
```

**With Stax:**
```shell
stax p
```
Stax (`p` is short for `pull`) handles switching to the main branch, pulling all the latest changes, deleting branches that have already been merged ("gone" branches), and switching you right back to where you were working.

## Typical Workflow with Stax

Here is what a normal day looks like when using Stax:

1. **Start fresh:** Run `stax p` (pull) to get the latest changes from your team.
2. **Do your work:** Write code, fix bugs, or add features.
3. **Save and share:** Run `stax c -u "my new feature"` (commit) to instantly branch, add updated files, commit, and push your work.
4. **Oops, forgot something?** Make your corrections and run `stax a -u` (amend) to update your work seamlessly.
5. **Check your progress:** Want to see where you are? Run `stax l` (log) to see a clear, visual tree structure of your branches.

## Commands Overview

Here is a quick cheat sheet grouping the most important commands. Note that many commands have short, single-letter aliases!

### Daily Usage

*   `stax l` or `stax log`: Shows you a tree of branches. Use the `-a` flag to show remote branches too.
*   `stax p` or `stax pull`: Does `git checkout/switch` to the default branch, pulls it, and returns back to the original branch. Will also check for any local branches that need a clean up.
*   `stax m` or `stax move`: Is a `git checkout/switch` alternative that uses directional movement based on a stax log graph. Directions are: `up`, `down`, `top`, `bottom`, `head` (a universal name for the default repository branch).
*   `stax r` or `stax rebase`: Similar to `git rebase` but you do not need to supply any arguments; it rebases the current branch on top of the head branch of the repository. Use the `-m` flag to not lose any changes from your branch.

### Committing

*   `stax c 'Commit message'` (or `stax commit`): Use when you want to start a new branch or open a Pull Request. First argument is the mandatory commit message, second is an optional branch name.
    *   `-u`: add updated files.
    *   `-a`: add all files in current folder and its parents.
    *   `-A`: add all files in all the folders of the repository.
    *   `-b`: accept branch name automatically.
    *   `-p`: open PR page.
    *   *Example:* `stax c -ubp "Commit message"` adds updated files, accepts the branch name automatically, and opens a PR page.

### Amending

*   `stax a` (or `stax amend`): Use when you want to add commits to the existing branch.
    *   `-u`: add updated files.
    *   `-a`: add all files in current folder and its parents.
    *   `-A`: add all files in all the folders of the repository.
    *   *Example:* `stax a -u` adds updated files to the existing commit.

Welcome to a simpler way to build software. Happy coding with Stax!