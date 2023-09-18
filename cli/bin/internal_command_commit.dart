import 'package:stax/external_command.dart';

import 'context_for_internal_command.dart';
import 'internal_command.dart';
import 'sanitize_branch_name.dart';

class InternalCommandCommit extends InternalCommand {
  InternalCommandCommit()
      : super(
            "commit",
            "Creates a branch, commits, and pushes it to remote. "
                "First argument is mandatory commit message. "
                "Second argument is optional branch name, if not provided "
                "branch name would be generated from commit message.");

  @override
  void run(final ContextForInternalCommand context) {
    if (context.args.isEmpty) {
      print("You need to provide commit message.");
      return;
    }
    if (context.git.diffCachedQuiet.runSync().exitCode == 0) {
      print("Can't commit - there is nothing staged. "
          "Run 'git add .' to add all the changes.");
      return;
    }
    final commitMessage = context.args[0];
    final String originalBranchName;
    if (context.args.length == 1) {
      originalBranchName = context.args[0];
      print("Second parameter wasn't provided. Will convert commit message to "
          "new branch name.");
    } else {
      originalBranchName = context.args[1];
    }
    final resultingBranchName = sanitizeBranchName(originalBranchName);
    if (originalBranchName != resultingBranchName) {
      if (!commandLineContinueQuestion(
          "Branch name was sanitized to '$resultingBranchName'.")) return;
    }
    print("Commit  message: '$commitMessage'");
    print("New branch name: '$resultingBranchName'");
    final newBranchCheckoutExitCode = context.git.checkoutNewBranch
        .arg(resultingBranchName)
        .announce()
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (newBranchCheckoutExitCode != 0) {
      print("Looks like we can't create new branch with '$resultingBranchName' "
          "name. Please pick a different name.");
      return;
    }
    context.git.commitWithMessage
        .arg(commitMessage)
        .announce()
        .runSync()
        .printNotEmptyResultFields();
    context.git.push.announce().runSync().printNotEmptyResultFields();
  }
}
