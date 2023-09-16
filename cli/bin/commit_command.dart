import 'package:stax/git.dart';

import 'command.dart';

class CommitCommand extends Command {
  CommitCommand()
      : super("commit", "creates a branch, commits, and pushes it to remote");

  @override
  void run(List<String> args) {
    if (args.isEmpty) {
      print("You need to provide commit message");
      return;
    }
    final commitMessage = args[0];
    String originalBranchName = args[0];
    String resultingBranchName = "";
    if (args.length > 1) {
      originalBranchName = args[1];
    }
    for (int i = 0; i < originalBranchName.length; i++) {
      if (resultingBranchName.isEmpty) {

      } else {

      }
    }
    if (originalBranchName != resultingBranchName) {

    }
    Git.checkout.withArguments(["-b", resultingBranchName]);
  }
}
