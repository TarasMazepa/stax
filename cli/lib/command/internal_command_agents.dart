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

This document (`agents.md`) provides explicit, direct instructions for AI assistants, LLMs, and autonomous agents on how to effectively use the `stax` CLI. Stax simplifies and automates multi-step Git workflows (branching, committing, pushing, and PR creation) into single commands.

## Explicit Commands & Usage

**1. Creating Commits and PRs (`stax commit`)**
Use `stax commit -ubd "JIRA-1234 Ticket description"` to: add files, create branch, commit, push, and open PR in draft mode.
*   **-u**: adds updated files.
*   **-a**: adds added files in current or child folders.
*   **-A**: adds added files in any folder of repository.
*   **-b**: accepts commit message to branch conversion.
*   **-d**: opens PR as a draft.
*   `JIRA-1234` should be a valid JIRA ticket that is currently assigned to you and in an "In progress" state or similar that is relevant to the active project.
*   `Ticket description` is the title of the ticket + a couple of words about the content of the PR.
*   *See `stax help commit` for more info.*

**2. Moving Around the Tree (`stax move`)**
Use `stax move head` to move back to the main branch. This works on any repository.
*   *See `stax help move` for more info.*

**3. Amending Commits (`stax a` or `stax amend`)**
`stax a` is perfect for amending the previous commit with new changes and force-pushing changes in one command.
*   Use `-u` for updated files.
*   Use `-a` or `-A` for adding new files.
*   If working in stacks, append `-r` to ensure child branches are rebased.
*   *See `stax help amend` for more info.*

**4. Force Pulling a Branch (`stax get`)**
`stax get <branch name>` is a perfect way to force pull a branch (WARNING: it will destroy your local changes).
*   A perfect tool if you work in parallel with someone who might force push changes (like stax amend).
*   *See `stax help get` for more info.*

## Efficient Chaining Rules
Do not leave room for interpretation. Use these specific command combinations instead of standard discrete Git operations. Never use raw Git commands when a Stax equivalent provides automated PR and branch management.
'''
          .trim(),
    );
  }
}
