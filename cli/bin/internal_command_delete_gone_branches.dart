import 'package:stax/context/context_for_internal_command.dart';
import 'package:stax/git/extract_branch_names.dart';
import 'package:stax/git/prepare_branch_names_for_extraction.dart';

import 'internal_command.dart';

class InternalCommandDeleteGoneBranches extends InternalCommand {
  InternalCommandDeleteGoneBranches()
      : super("delete-gone-branches",
            "Deletes local branches with gone remotes.");

  @override
  void run(final ContextForInternalCommand context) {
    context.git.fetchWithPrune
        .announce("Fetching latest changes from remote.")
        .runSync()
        .printNotEmptyResultFields();
    final branchesToDelete = context.git.branchVv
        .announce("Checking if any remote branches are gone.")
        .runSync()
        .printNotEmptyResultFields()
        .prepareBranchNameForExtraction()
        .where((element) => element[0] != "*" && element.contains(": gone] "))
        .extractBranchNames()
        .toList();
    if (branchesToDelete.isEmpty) {
      context.context.printToConsole("No local branches with gone remotes.");
      return;
    }
    context.git.branchDelete
        .args(branchesToDelete)
        .askContinueQuestion(
            "Local branches with gone remotes that would be deleted: ${branchesToDelete.join(", ")}.")
        ?.announce("Deleting branches.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
