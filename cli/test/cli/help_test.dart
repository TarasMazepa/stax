import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'base/cli_group.dart';

void main() {
  cliGroup("help", (setup) {
    test("help", () {
      expect(setup.runLiveStaxSync(["help"]).stdout, """Global flags:
   --accept-all - Accept all the user prompts automatically.
   --decline-all - Decline all the user prompts automatically.
   --loud - Force all the output.
   --silent - Removes all output except user prompts.
Here are available commands:
 • amend - Amends and pushes changes.
      Flags:
         -a - Runs 'git add .' before other actions. Which adds tracked and untracked files.
         -u - Runs 'git add -u .' before other actions. Which adds only tracked files.
 • checkout - checkout PR stack
      Positional arguments:
         arg1 - name of the remote ref
 • commit - Creates a branch, commits, and pushes it to remote. First argument is mandatory commit message. Second argument is optional branch name, if not provided branch name would be generated from commit message.
      Positional arguments:
         arg1 - Required commit message, usually enclosed in double quotes like this: "Sample commit message".
         opt2 - Optional branch name, if not provided commit message would be converted to branch name.
      Flags:
         -a - Runs 'git add .' before other actions. Which adds tracked and untracked files.
         -b - Accepts branch name proposed by converting commit name to branch name.
         --pr - Opens PR creation page on your remote. Works only if you have GitHub as your remote.
         -u - Runs 'git add -u .' before other actions. Which adds only tracked files.
 • delete-gone-branches - Deletes local branches with gone remotes.
      Flags:
         -f - Force delete gone branches.
         -s - Skip deletion of gone branches.
 • doctor - Helps to ensure that stax has everything to be used.
 • help - List of available commands.
      Flags:
         -a - Show all commands including hidden.
 • log - Builds a tree of all branches.
      Flags:
         -a - show remote branches also
         --default-branch - assume different default branch
 • pull - Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.
      Flags:
         -f - Force delete gone branches.
         -s - Skip deletion of gone branches.
 • version - Version of stax
""");
    });
  });
}
