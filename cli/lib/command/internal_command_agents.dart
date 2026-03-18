import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandAgents extends InternalCommand {
  InternalCommandAgents()
    : super(
        'agents.md',
        'Output agents.md text explaining to LLMs how to use stax effectively.',
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    context.printToConsole(
      '''
# Stax for Git - LLM Agent Usage Guide

This document (`agents.md`) serves as a guide for AI assistants, LLMs, and autonomous agents to understand and use the `stax` CLI effectively.

## Benefits of Stax

Stax is a command-line tool designed to simplify standard Git workflows for users familiar with Git but overwhelmed by its complexity. It automates multi-step processes like branching, committing, pushing, and rebasing into unified commands.

Key benefits for LLMs:
*   **Reduced Complexity:** Instead of issuing 4-5 discrete git commands (checkout, branch, commit, push, rebase), you can achieve the same with a single stax command.
*   **Automated PR Management:** Creates and manages stacked PRs seamlessly on GitHub.
*   **Predictable Workflows:** Standardizes the way code is structured into discrete, reviewable units.

## Core Commands & Maximalist Examples

Here are the most critical `stax` commands, showcasing how to use flags to combine actions efficiently:

### 1. Committing and Creating PRs (`stax commit`)
The `commit` command creates a branch, commits changes, and pushes to remote in one go.

*   **Maximalist Example:**
    ```bash
    stax commit -A -p "Implement user authentication flow" user-auth-flow
    ```
    *Explanation:*
    *   `-A`: Automatically runs `git add -A` to stage all tracked and untracked changes before committing.
    *   `-p`: Opens a pull request on the remote (e.g., GitHub).
    *   `"Implement user authentication flow"`: The required commit message.
    *   `user-auth-flow`: (Optional) Explicitly defines the branch name. If omitted, `stax` derives it from the commit message.

### 2. Amending Existing Commits (`stax amend`)
When you need to update an existing PR or commit, `amend` seamlessly updates the commit and force-pushes.

*   **Maximalist Example:**
    ```bash
    stax amend -a -r
    ```
    *Explanation:*
    *   `-a`: Automatically runs `git add .` to stage tracked/untracked changes in the current folder before amending.
    *   `-r`: Automatically runs `stax rebase` afterwards on all children branches that depend on this one, keeping stacked PRs in sync.

### 3. Syncing with Main (`stax pull`)
Instead of manually checking out main, pulling, and switching back, `stax pull` handles the entire synchronization loop.

*   **Example:**
    ```bash
    stax pull -f
    ```
    *Explanation:*
    *   Switches to the main branch, pulls latest changes.
    *   `-f`: Force deletes local branches whose remotes are gone (merged or closed).
    *   Switches back to the original branch.

### 4. Rebasing Stacked PRs (`stax rebase`)
Rebases a tree of branches on top of main or a specified target.

*   **Example:**
    ```bash
    stax rebase --prefer-moving
    ```
    *Explanation:*
    *   Rebases the current branch structure.
    *   `--prefer-moving` (or `-m`): In case of a conflict, automatically prefers the incoming "moving" changes (your branch's changes) over the base.

## Efficient Chaining Rules for LLMs

When generating bash scripts or executing commands:
1.  **Prefer built-in flags over manual Git steps:** Use `stax commit -A` instead of `git add -A && stax commit`.
2.  **Combine commit and PR creation:** Always use `-p` with `stax commit` if the intent is to create a PR immediately.
3.  **Use `-r` with `amend` when working in stacks:** If you modify a branch that has dependent branches, `stax amend -r` prevents the stack from breaking.
'''
          .trim(),
    );
  }
}
