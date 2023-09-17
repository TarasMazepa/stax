import 'package:stax/external_command.dart';
import 'package:stax/git.dart';
import 'package:stax/process_result_print.dart';

import 'command.dart';
import 'sanitize_branch_name.dart';

class CommitCommand extends Command {
  CommitCommand()
      : super(
            "commit",
            "Creates a branch, commits, and pushes it to remote. "
                "First argument is mandatory commit message. "
                "Second argument is optional branch name, if not provided "
                "branch name would be generated from commit message.");

  @override
  void run(List<String> args) {
    if (args.isEmpty) {
      print("You need to provide commit message.");
      return;
    }
    if (Git.diffCachedQuiet.runSync().exitCode == 0) {
      print("Can't commit - there is nothing staged. "
          "Run 'git add .' to add all the changes.");
      return;
    }
    final commitMessage = args[0];
    final String originalBranchName;
    if (args.length == 1) {
      originalBranchName = args[0];
      print("Second parameter wasn't provided. Will convert commit message to "
          "new branch name.");
    } else {
      originalBranchName = args[1];
    }
    final resultingBranchName = sanitizeBranchName(originalBranchName);
    if (originalBranchName != resultingBranchName) {
      if (!commandLineContinueQuestion(
          "Branch name was sanitized to '$resultingBranchName'.")) return;
    }
    print("Commit  message: '$commitMessage'");
    print("New branch name: '$resultingBranchName'");
    final newBranchCheckoutExitCode = Git.checkoutNewBranch
        .withArgument(resultingBranchName)
        .announce()
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (newBranchCheckoutExitCode != 0) {
      print("Looks like we can't create new branch with '$resultingBranchName' "
          "name. Please pick a different name.");
      return;
    }
    Git.commitWithMessage
        .withArgument(commitMessage)
        .announce()
        .runSync()
        .printNotEmptyResultFields();
    Git.push.announce().runSync().printNotEmptyResultFields();
  }
}
