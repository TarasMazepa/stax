import 'package:stax/git.dart';
import 'package:stax/nullable_index_of.dart';

import 'context_for_internal_command.dart';
import 'internal_command.dart';

class InternalCommandDeleteGoneBranches extends InternalCommand {
  InternalCommandDeleteGoneBranches()
      : super("delete-gone-branches",
            "Deletes local branches with gone remotes.");

  @override
  void run(final ContextForInternalCommand arguments) {
    Git.fetchWithPrune.announce().runSync().printNotEmptyResultFields();
    final branchesToDelete = Git.branchVv
        .announce()
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .where((element) => element.length > 2)
        .where((element) => element[0] != "*" && element.contains(": gone] "))
        .map((e) => e.substring(2, e.indexOf(" ", 2).toNullableIndexOfResult()))
        .toList();
    if (branchesToDelete.isEmpty) {
      print("No local branches with gone remotes.");
      return;
    }
    Git.branchDelete
        .withArguments(branchesToDelete)
        .askContinueQuestion(
            "Local branches with gone remotes that would be deleted: ${branchesToDelete.join(", ")}.")
        ?.announce()
        .runSync()
        .printNotEmptyResultFields();
  }
}
