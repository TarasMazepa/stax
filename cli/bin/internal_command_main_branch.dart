import 'package:stax/git.dart';

import 'arguments_for_internal_command.dart';
import 'internal_command.dart';

class InternalCommandMainBranch extends InternalCommand {
  InternalCommandMainBranch()
      : super("main-branch", "Shows which branch stax considers to be main.");

  @override
  void run(final ArgumentsForInternalCommand arguments) {
    final remotes = Git.remote
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
        print("You have no remotes. Can't figure out default branch.");
        return;
      case 1:
        remote = remotes.first;
      default:
        print("You have many remotes. I will just pick the first one.");
        remote = remotes.first;
    }
    final defaultBranch = Git.revParseAbbrevRef
        .withArgument("$remote/HEAD")
        .announce("Checking default branch on remote")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim()
        .split("/")[1];
    print("Your main branch is $defaultBranch.");
  }
}
