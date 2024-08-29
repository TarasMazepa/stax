import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/external_command/extended_process_result.dart';

import 'internal_command.dart';
import 'internal_command_delete_gone_branches.dart';

class InternalCommandPull extends InternalCommand {
  InternalCommandPull()
      : super(
          "pull",
          "Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.",
          flags: {}
            ..addAll(InternalCommandDeleteGoneBranches.forceDeleteFlagEntry)
            ..addAll(InternalCommandDeleteGoneBranches.skipDeleteFlagEntry),
        );

  @override
  void run(List<String> args, Context context) {
    /**
     * TODO:
     *  - Warn about deleting branch on which user was originally
     */
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    final currentBranch = context.getCurrentBranch();
    final defaultBranch = context.getDefaultBranch();
    if (defaultBranch == null) {
      context.printToConsole(
        "Can't do pull on default branch, as can't identify one.",
      );
      return;
    }
    bool needToSwitchBranches = currentBranch != defaultBranch;
    ExtendedProcessResult? result;
    if (needToSwitchBranches) {
      result = context.git.checkout
          .arg(defaultBranch)
          .announce("Switching to default branch '$defaultBranch'.")
          .runSync()
          .printNotEmptyResultFields()
          .assertSuccessfulExitCode();
      if (result == null) return;
    }
    result = context.git.pull
        .announce("Pulling new changes.")
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode();
    if (result == null) return;
    InternalCommandDeleteGoneBranches().run(
      args
          .where(
            (x) =>
                x == InternalCommandDeleteGoneBranches.forceDeleteFlag ||
                x == InternalCommandDeleteGoneBranches.skipDeleteFlag,
          )
          .toList(),
      context,
    );
    if (needToSwitchBranches && currentBranch != null) {
      context.git.checkout
          .arg(currentBranch)
          .announce("Switching back to original branch '$currentBranch'.")
          .runSync()
          .printNotEmptyResultFields();
    }
  }
}
