import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';

import 'internal_command.dart';
import 'sanitize_branch_name.dart';

class InternalCommandCommit extends InternalCommand {
  InternalCommandCommit()
      : super(
            "commit",
            "Creates a branch, commits, and pushes it to remote. "
                "First argument is mandatory commit message. "
                "Second argument is optional branch name, if not provided "
                "branch name would be generated from commit message.",
            flags: {}..addAll(ContextHandleAddAllFlag.description),
            arguments: {
              "arg1":
                  "Required commit message, usually enclosed in double quotes like this: \"Sample commit message\".",
              "opt2":
                  "Optional branch name, if not provided commit message would be converted to branch name.",
            });

  @override
  void run(final List<String> args, final Context context) {
    if (args.isEmpty) {
      context.printToConsole("You need to provide commit message.");
      return;
    }
    context.handleAddAllFlag(args);
    if (context.isThereNoStagedChanges()) {
      context.printToConsole("Can't commit - there is nothing staged. "
          "Run 'git add .' to add all the changes. "
          "If that haven't worked - try editing some files.");
      return;
    }
    final commitMessage = args[0];
    final String originalBranchName;
    if (args.length == 1) {
      originalBranchName = args[0];
      context.printToConsole(
          "Second parameter wasn't provided. Will convert commit message to new branch name.");
    } else {
      originalBranchName = args[1];
    }
    final resultingBranchName = sanitizeBranchName(originalBranchName);
    if (originalBranchName != resultingBranchName) {
      if (!context.commandLineContinueQuestion(
          "Branch name was sanitized to '$resultingBranchName'.")) return;
    }
    context.printToConsole("Commit  message: '$commitMessage'");
    context.printToConsole("New branch name: '$resultingBranchName'");
    final newBranchCheckoutExitCode = context.git.checkoutNewBranch
        .arg(resultingBranchName)
        .announce("Creating new branch.")
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (newBranchCheckoutExitCode != 0) {
      context.printToConsole(
          "Looks like we can't create new branch with '$resultingBranchName' name. Please pick a different name.");
      return;
    }
    context.git.commitWithMessage
        .arg(commitMessage)
        .announce("Committing")
        .runSync()
        .printNotEmptyResultFields();
    context.git.push.announce("Pushing").runSync().printNotEmptyResultFields();
  }
}
