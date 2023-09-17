import 'package:stax/git.dart';

import 'command.dart';
import 'sanitize_branch_name.dart';

class CommitCommand extends Command {
  CommitCommand()
      : super("commit", "Creates a branch, commits, and pushes it to remote.");

  @override
  void run(List<String> args) {
    if (args.isEmpty) {
      print("You need to provide commit message");
      return;
    }
    final commitMessage = args[0];
    String originalBranchName = args.length > 1 ? args[1] : args[0];
    String resultingBranchName = sanitizeBranchName(originalBranchName);
    if (originalBranchName != resultingBranchName) {
      // ask user if it is ok to name branch like that.
    }
    Git.checkout.withArguments(["-b", resultingBranchName]);
    Git.commit.withArguments(["-m", commitMessage]);
  }
}
