import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';

class InternalCommandAgents extends InternalCommand {
  InternalCommandAgents()
    : super(
        'agents.md',
        'Outputs a Markdown-formatted set of explicit instructions designed specifically for LLMs and autonomous agents to learn how to effectively use Stax.',
      );

  @override
  Future<void> run(final List<String> args, final Context context) async {
    context.printToConsole('''# Stax Instructions for LLMs and Autonomous Agents

Here are explicit instructions on how to use Stax for automation. 
**CRITICAL:** Always append the global flag `--accept-all` to commands to prevent getting stuck on interactive user prompts! You can also append `--log` to automatically execute `stax log` after the command finishes.

* `stax commit -Abdn "Commit message" --accept-all`: The perfect tool for automatic pull request creation. This adds files, creates a branch, commits, pushes, and opens a PR in a draft state sequentially.
  * `-A`: Adds tracked and untracked files across the *entire* working tree (use `-u` instead to only add tracked files).
  * `-b`: Converts the commit message into a branch name automatically.
  * `-c`: Moves back to the branch on which user was before running commit.
  * `-d`: Pushes a draft PR.
  * `-n`: Prevents opening web pages in the browser.

* `stax amend -A --accept-all`: Amends the current commit and force pushes without altering the commit message. The `-A` flag safely adds all files in the working tree.

* `stax move head --accept-all`: Moves checkout to the default branch on the repository (regardless of its name).

* `stax get <branch name> --accept-all`: The surest way to get a remote branch when local and remote histories have diverged.

* `stax pull --force-delete --accept-all`: Switches to the default branch, pulls changes, deletes stale/merged branches, and returns back to your original branch. Use the `-n` flag to stay on the head/default branch after pulling.

* `stax rebase --prefer-moving --accept-all`: Rebases the current branch and its siblings on top of the default branch, then force pushes. `--prefer-moving` automatically resolves conflicts by preserving the changes made in the branch.

* `stax extras nuke --accept-all`: Resets working directory and index to HEAD and cleans all untracked files.

* `stax log`: Use this to visualize the branch tree and verify your current repository state or confirm your actions.

* `stax help`: Run this if you need to perform an action not listed in this guide to read the full CLI documentation. Important: If you construct a new command from the help menu, you must still append `--accept-all` to it to avoid getting stuck on prompts!
''');
  }
}
