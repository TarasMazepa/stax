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
    String originalBranchName = args.length > 1 ? args[1] : args[0];
    String resultingBranchName = sanitizeBranchName(originalBranchName);
    final checkout = Git.checkoutNewBranch.withArgument(resultingBranchName);
    if (originalBranchName != resultingBranchName) {
      if (checkout.askContinueQuestion(
              "Branch name was sanitized to '$resultingBranchName'.") ==
          null) return;
    }
    checkout.announce().runSync().printNotEmptyResultFields();
    Git.commit
        .withArguments(["-m", commitMessage])
        .announce()
        .runSync()
        .printNotEmptyResultFields();
    Git.push.announce().runSync().printNotEmptyResultFields();
  }
}
