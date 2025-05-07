import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup('help', (setup) {
    test('help', () {
      expect(setup.runLiveStaxSync(['help']).stdout, """Global flags:
   --accept-all - Accept all the user prompts automatically.
   --decline-all - Decline all the user prompts automatically.
   --loud - Force all the output.
   --silent - Removes all output except user prompts.
Here are available commands:
Note: you can type first letter or couple of first letters instead of full command name. 'c' for 'commit' or 'am' for 'amend'.
 • amend - Amends and pushes changes.
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
         -b - Accepts branch name proposed by converting commit name to branch name.
         -i, --ignore-no-staged-changes - Skips check if there staged changes, helpful when your change is only rename of the file which stax can't see at the moment.
         -p, --pr - Opens PR creation page on your remote. Works only if you have GitHub as your remote.
         -u - Runs 'git add -u' before other actions. Which adds only tracked files in whole working tree.
 • delete - Deletes local branches with gone remotes.
      Flags:
         -f - Force delete gone branches.
         -s - Skip deletion of gone branches.
 • doctor - Helps to ensure that stax has everything to be used.
 • get - (Re)Checkout specified branch and all its children
      Positional arguments:
         opt1 - Name of the remote ref. Will be matched as a suffix.
 • help - List of available commands.
      Flags:
         -a - Show all commands including hidden.
 • log - Shows a tree of all branches.
      Flags:
         -a, --all - show remote branches also
         -d, --default-branch - assume different default branch
         -w, --watch - watch for git changes and re-run
 • move - Allows you to move around log tree. Note: you can type any amount of first letters to specify direction. 'h' instead of 'head', 't' for 'top, 'd' for down, 'u' for 'up', 'b' for 'bottom'
      Positional arguments:
         [arg]+ - up (one up, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), down (one down), top (to the closest top parent that have at least two children or to the top most node, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), bottom (to the closest bottom parent that have at least two children or bottom most node, will stop before any direct parent of <remote>/head), head (<remote>/head)
 • pull, p - Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.
      Positional arguments:
         opt1 - Optional target branch, will default to <remote>/HEAD
      Flags:
         -f - Force delete gone branches.
         -s - Skip deletion of gone branches.
 • pull-request, pr - Creates a pull request.
 • rebase - rebase tree of branches on top of main
      Positional arguments:
         opt1 - Optional argument for target, will default to <remote>/HEAD
      Flags:
         -a, --abandon - Abandon rebase that is in progress, stax can't abort own rebases.
         -b, --prefer-base - Prefer base changes on conflict.
         -c, --continue - Continue rebase that is in progress.
         -m, --prefer-moving - Prefer moving changes on conflict.
 • settings - View or modify stax settings
      Positional arguments:
         arg1 - Subcommand (add, clear, remove, set, show)
         opt2 - Setting name
         opt3 - Setting value
      Flags:
         -g, --global - Perform operation on global settings regardless of invocation path.
 • version - Version of stax
""");
    });
  });
}
