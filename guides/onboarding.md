# Stax Onboarding Guide for Beginners

Welcome to Stax! If you use Git but find it confusing or overwhelming, this guide is for you. Stax is built to simplify your workflow, automating the most complex parts of Git so you can focus on writing code instead of struggling with branching and pushing.

## The Core Concept

In standard Git, saving and sharing your code requires a multi-step dance: making a branch, adding your files, committing with a message, and pushing to a remote repository while setting an upstream tracking branch.

**With Stax, you just tell it what your change is about, and it handles the rest.** You make your changes, you tell Stax to save them (commit), and it takes care of the complicated background work.

## Highlighting Simplicity: Stax vs. Regular Git

Let's look at how much simpler Stax makes your day-to-day work compared to regular Git.

### Saving and Uploading Your Work

**Regular Git:**
```shell
git checkout -b your-branch-name
git add .
git commit -m "your message"
git push -u origin your-branch-name
```

**With Stax:**
```shell
stax commit "your message"
```
*That's it!* Stax automatically creates a branch, stages your changes, commits them, and pushes them to your remote repository.

### Updating Your Current Work

If you missed a file, made a typo, or received feedback and need to update your current branch:

**Regular Git:**
```shell
git add .
git commit --amend --no-edit
git push --force-with-lease
```

**With Stax:**
```shell
stax amend
```
Stax adds your new changes to the existing commit and safely force-pushes the update.

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
stax pull
```
Stax handles switching to the main branch, pulling all the latest changes, deleting branches that have already been merged ("gone" branches), and switching you right back to where you were working.

## Typical Workflow with Stax

Here is what a normal day looks like when using Stax:

1. **Start fresh:** Run `stax pull` to get the latest changes from your team.
2. **Do your work:** Write code, fix bugs, or add features.
3. **Save and share:** Run `stax commit "my new feature"` to instantly branch, commit, and push your work.
4. **Oops, forgot something?** Make your corrections and run `stax amend` to update your work seamlessly.
5. **Check your progress:** Want to see where you are? Run `stax log` to see a clear, visual tree structure of your branches.
6. **Clean up:** Run `stax delete-stale` (or simply `stax pull`) to automatically clean up your local branches once your work has been merged and deleted from the remote repository.

## Commands Overview

*   `stax commit "message"`: The ultimate time-saver. Branches, commits, and pushes in one step.
*   `stax amend`: Updates your current commit and force pushes the branch.
*   `stax pull`: Syncs your local project with the latest changes from your team and cleans up old branches.
*   `stax log`: Shows a simple tree of all your branches so you always know where you are.
*   `stax delete-stale`: Cleans up local branches whose remote counterparts have been deleted.

Welcome to a simpler way to build software. Happy coding with Stax!