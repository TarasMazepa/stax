import 'context_for_internal_command.dart';
import 'internal_command.dart';
import 'internal_command_stopped_execution_exception.dart';
import 'types_for_internal_command.dart';

class InternalCommandMainBranch extends InternalCommand {
  InternalCommandMainBranch()
      : super("main-branch", "Shows which branch stax considers to be main.",
            type: InternalCommandType.hidden);

  String getDefaultBranchName(final ContextForInternalCommand context) {
    final remotes = context.git.remote
        .announce("Checking name of your remote.")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty);
    final String remote;
    switch (remotes.length) {
      case 0:
        context.printToConsole(
            "You have no remotes. Can't figure out default branch.");
        throw InternalCommandStoppedExecutionException();
      case 1:
        remote = remotes.first;
      default:
        context.printToConsole(
            "You have many remotes. I will just pick the first one.");
        remote = remotes.first;
    }
    final defaultBranch = context.git.revParseAbbrevRef
        .arg("$remote/HEAD")
        .announce("Checking default branch on remote")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim()
        .split("/")[1];
    context.printToConsole("Your main branch is $defaultBranch.");
    return defaultBranch;
  }

  @override
  void run(final ContextForInternalCommand context) {
    try {
      getDefaultBranchName(context);
    } on InternalCommandStoppedExecutionException {
      return;
    }
  }
}
