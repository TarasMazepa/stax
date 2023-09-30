import 'package:stax/context/context.dart';

import 'internal_command.dart';
import 'internal_command_stopped_execution_exception.dart';
import 'types_for_internal_command.dart';

class InternalCommandMainBranch extends InternalCommand {
  InternalCommandMainBranch()
      : super("main-branch", "Shows which branch stax considers to be main.",
            type: InternalCommandType.hidden);

  String getDefaultBranchName(final List<String> args, final Context context) {
    final remotes = context.git.remote
        .announce("Checking name of your remote.")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
    if (remotes.isEmpty) {
      context.printToConsole(
          "You have no remotes. Can't figure out default branch.");
      throw InternalCommandStoppedExecutionException();
    }
    final defaultBranches = remotes
        .map((remote) => (
              remote: remote,
              parts: context.git.revParseAbbrevRef
                  .arg("$remote/HEAD")
                  .announce("Checking default branch on '$remote' remote")
                  .runSync()
                  .printNotEmptyResultFields()
                  .stdout
                  .toString()
                  .trim()
                  .split("/")
            ))
        .where((e) => e.parts.length == 2)
        .where((e) => e.remote == e.parts[0])
        .map((e) => e.parts[1])
        .toSet()
        .toList();
    final defaultBranch = switch (defaultBranches) {
      [] => throw InternalCommandStoppedExecutionException(),
      [final one] => one,
      _ => defaultBranches.first
    };
    context.printToConsole("Your main branch is $defaultBranch.");
    return defaultBranch;
  }

  @override
  void run(final List<String> args, final Context context) {
    try {
      getDefaultBranchName(args, context);
    } on InternalCommandStoppedExecutionException {
      return;
    }
  }
}
