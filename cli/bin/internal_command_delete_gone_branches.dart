import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_fetch_with_prune.dart';
import 'package:stax/git/branch_info.dart';

import 'internal_command.dart';

class InternalCommandDeleteGoneBranches extends InternalCommand {
  InternalCommandDeleteGoneBranches()
      : super("delete-gone-branches",
            "Deletes local branches with gone remotes.");

  @override
  void run(final List<String> args, final Context context) {
    /**
     * TODO:
     *  - Adds shorter command version, like "cleanup"
     */
    context.fetchWithPrune();
    final branchesToDelete = context.git.branchVv
        .announce("Checking if any remote branches are gone.")
        .runSync()
        .printNotEmptyResultFields()
        .parseBranchInfo()
        .where((e) => e.gone)
        .map((e) => e.name)
        .toList();
    if (branchesToDelete.isEmpty) {
      context.printToConsole("No local branches with gone remotes.");
      return;
    }
    context.git.branchDelete
        .args(branchesToDelete)
        .askContinueQuestion(
            "Local branches with gone remotes that would be deleted:\n${branchesToDelete.map((e) => "   • $e").join("\n")}\n")
        ?.announce("Deleting branches.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
