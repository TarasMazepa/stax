import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../string_clean_carrige_return_on_windows.dart';
import 'base/cli_group.dart';

void main() {
  cliGroup('help', (setup) {
    test('help', () async {
      expect(
        setup
            .runLiveStaxSync(['help'])
            .stdout
            .toString()
            .cleanCarriageReturnOnWindows(),
        """Global flags:
   --accept-all - Accept all the user prompts automatically.
   --decline-all - Decline all the user prompts automatically.
   -h, --help - Shows help documentation for the command
   --log - Output log after finishing running requested command
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
         --skip-rebase - Skip asking for rebase entirely.
         -u - Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.
 • commit - Creates a branch, commits, and pushes it to remote. First argument is mandatory commit message. Second argument is optional branch name, if not provided branch name would be generated from commit message.
      Positional arguments:
         arg1 - Required commit message, usually enclosed in double quotes like this: "Sample commit message".
         opt2 - Optional branch name, if not provided commit message would be converted to branch name.
      Flags:
         -A - Runs 'git add -A' before other actions. Which adds tracked and untracked files in whole working tree.
         -a - Runs 'git add .' before other actions. Which adds tracked and untracked files in current folder and subfolders.
         -b, --branch-from-commit - Accepts branch name proposed by converting commit name to branch name.
         -c, --come-back - Moves back to the branch on which user was before running commit.
         -d, --draft - Creates a PR in draft mode using the GitHub CLI. Works only if you have GitHub as your remote.
         -i, --ignore-no-staged-changes - Skips check if there staged changes, helpful when your change is only rename of the file which stax can't see at the moment.
         -n, --no-browser - Do not attempt to open the PR URL in the browser.
         -p, --pull-request - Opens PR creation page on your remote. Works only if you have GitHub as your remote.
         -u - Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.
 • delete-stale, d - Deletes local branches with gone remotes.
      Flags:
         -f, --force-delete - Force delete gone branches.
         -s, --skip-delete - Skip deletion of gone branches.
 • extras, e - Extra non-primary commands (about, agents.md, changelog, doctor, nuke, settings, update, version). Run `stax extras` to see detailed list.
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
 • help - List of available commands.
      Positional arguments:
         opt1 - Optional name of the command you want to learn about
      Flags:
         -a, --show-all - Show all commands including hidden.
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
         -n, --no-switch-back - Stay on the head/default branch after pulling.
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
""",
      );
    });

    test('extras help', () async {
      expect(
        setup
            .runLiveStaxSync(['extras', 'help'])
            .stdout
            .toString()
            .cleanCarriageReturnOnWindows(),
        """Global flags:
   --accept-all - Accept all the user prompts automatically.
   --decline-all - Decline all the user prompts automatically.
   -h, --help - Shows help documentation for the command
   --log - Output log after finishing running requested command
   -q, --quiet - Removes all output except user prompts.
   -v, --verbose - Force all the output.
Here are available commands under `extras`:
Note: you can type first letter or couple of first letters instead of full command name. 'c' for 'commit' or 'am' for 'amend'.
 • about - Shows information about the stax.
 • agents.md - Outputs a Markdown-formatted set of explicit instructions designed specifically for LLMs and autonomous agents to learn how to effectively use Stax.
 • changelog - Shows the stax changelog.
      Flags:
         -s, --show-only-latest - show specific amount of versions
 • doctor - Helps to ensure that stax has everything to be used.
      Flags:
         -j, --json - output in json format
 • nuke - Resets working directory and index to HEAD and cleans all untracked files.
 • settings - View or modify stax settings
      Positional arguments:
         arg1 - Subcommand (add, clear, remove, set, show)
         opt2 - Setting name
         opt3 - Setting value
      Flags:
         -g, --global - Perform operation on global settings regardless of invocation path.
 • update - Updates to the latest version.
 • version - Version of stax
""",
      );
    });

    test('help command matching by prefix', () async {
      expect(
        setup
            .runLiveStaxSync(['help', 'c'])
            .stdout
            .toString()
            .cleanCarriageReturnOnWindows(),
        """Global flags:
   --accept-all - Accept all the user prompts automatically.
   --decline-all - Decline all the user prompts automatically.
   -h, --help - Shows help documentation for the command
   --log - Output log after finishing running requested command
   -q, --quiet - Removes all output except user prompts.
   -v, --verbose - Force all the output.
 • commit - Creates a branch, commits, and pushes it to remote. First argument is mandatory commit message. Second argument is optional branch name, if not provided branch name would be generated from commit message.
      Positional arguments:
         arg1 - Required commit message, usually enclosed in double quotes like this: "Sample commit message".
         opt2 - Optional branch name, if not provided commit message would be converted to branch name.
      Flags:
         -A - Runs 'git add -A' before other actions. Which adds tracked and untracked files in whole working tree.
         -a - Runs 'git add .' before other actions. Which adds tracked and untracked files in current folder and subfolders.
         -b, --branch-from-commit - Accepts branch name proposed by converting commit name to branch name.
         -c, --come-back - Moves back to the branch on which user was before running commit.
         -d, --draft - Creates a PR in draft mode using the GitHub CLI. Works only if you have GitHub as your remote.
         -i, --ignore-no-staged-changes - Skips check if there staged changes, helpful when your change is only rename of the file which stax can't see at the moment.
         -n, --no-browser - Do not attempt to open the PR URL in the browser.
         -p, --pull-request - Opens PR creation page on your remote. Works only if you have GitHub as your remote.
         -u - Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.
""",
      );
    });
  });
}
