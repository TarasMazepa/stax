import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_fetch_with_prune.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/git/branch_info.dart';

import 'internal_command.dart';

class InternalCommandDeleteGoneBranches extends InternalCommand {
  static final String forceDeleteFlag = "-f";
  static final String skipDeleteFlag = "-s";
  static final forceDeleteFlagEntry = {
    forceDeleteFlag: "Force delete gone branches."
  };
  static final skipDeleteFlagEntry = {
    skipDeleteFlag: "Skip deletion of gone branches."
  };

  InternalCommandDeleteGoneBranches()
      : super(
          "delete-gone-branches",
          "Deletes local branches with gone remotes.",
          flags: {}
            ..addAll(forceDeleteFlagEntry)
            ..addAll(skipDeleteFlagEntry),
        );

  @override
  void run(final List<String> args, final Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
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
          "Local branches with gone remotes that would be deleted:\n${branchesToDelete.map((e) => "   • $e").join("\n")}\n",
          assumeYes: args.contains(forceDeleteFlag),
          assumeNo: args.contains(skipDeleteFlag),
        )
        ?.announce("Deleting branches.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
