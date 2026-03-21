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

Here are explicit instructions on how to use Stax for automation:

* `stax commit -abdn "Commit message"`: A perfect tool for automatic pull request creation. This command adds files, creates a branch, commits, pushes, and opens a PR in a draft state sequentially.
  * `-a`: Adds all files into git.
  * `-b`: Converts the commit message to a branch name.
  * `-d`: Pushes a draft PR.
  * `-n`: Prevents opening web pages.

* `stax amend -a`: Amends the current commit and force pushes without adding a new commit name. The `-a` flag adds all files.

* `stax move head`: Moves to the default branch on the repository (regardless of its name).

* `stax get <branch name>`: A sure way to get a remote branch when local and remote have diverged.

* `stax pull --force-delete`: Switches to the default branch, pulls changes, and deletes stale branches.
''');
  }
}
