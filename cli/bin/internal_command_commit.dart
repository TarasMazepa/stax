import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/context/context_explain_to_user_no_staged_changes.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';

import 'internal_command.dart';
import 'sanitize_branch_name.dart';

class InternalCommandCommit extends InternalCommand {
  static const prFlag = "--pr";

  InternalCommandCommit()
      : super(
            "commit",
            "Creates a branch, commits, and pushes it to remote. "
                "First argument is mandatory commit message. "
                "Second argument is optional branch name, if not provided "
                "branch name would be generated from commit message.",
            flags: {
              prFlag:
                  "Opens PR creation page on your remote. Works only if you have GitHub as your remote."
            }..addAll(ContextHandleAddAllFlag.description),
            arguments: {
              "arg1":
                  "Required commit message, usually enclosed in double quotes like this: \"Sample commit message\".",
              "opt2":
                  "Optional branch name, if not provided commit message would be converted to branch name.",
            });

  @override
  void run(final List<String> args, final Context context) {
    context.handleAddAllFlag(args);
    final createPr = args.remove(prFlag);
    if (context.isThereNoStagedChanges()) {
      context.explainToUserNoStagedChanges();
      return;
    }
    if (args.isEmpty) {
      context.printToConsole(
          "You need to provide commit message. Something like this: 'stax commit \"My new commit message\"'");
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
    final previousBranch = createPr ? context.getCurrentBranch() : null;
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
    if (createPr) {
      final remote = context.git.remote.runSync().stdout.toString().trim();
      final remoteUrl = context.git.remoteGetUrl
          .arg(remote)
          .runSync()
          .stdout
          .toString()
          .trim();
      final newPrUrl =
          "${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$previousBranch...$resultingBranchName?expand=1";
      final openCommand = () {
        if (Platform.isWindows) {
          return [
            "PowerShell",
            "-Command",
            """& {Start-Process "$newPrUrl"}""",
          ];
        }
        return ["open", newPrUrl];
      }();

      context.command(openCommand).runSync();
    }
  }
}
