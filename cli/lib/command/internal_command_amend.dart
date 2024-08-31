import 'package:stax/context/context.dart';
import 'package:stax/context/context_explain_to_user_no_staged_changes.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_get_child_branches.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';

import 'internal_command.dart';

class InternalCommandAmend extends InternalCommand {
  InternalCommandAmend()
      : super(
          "amend",
          "Amends and pushes changes.",
          flags: [...ContextHandleAddAllFlag.flags],
        );

  @override
  void run(final List<String> args, final Context context) {
    /**
     * TODO:
     *  - Rebase
     */
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context.handleAddAllFlag(args);
    if (context.areThereNoStagedChanges()) {
      context.explainToUserNoStagedChanges();
      return;
    }
    final childBranches = context.getChildBranches();
    context.git.commitAmendNoEdit
        .announce("Amending changes to a commit.")
        .runSync()
        .printNotEmptyResultFields();
    final rebaseTarget = context.getCurrentBranch() ??
        context.git.revParseHead
            .announce("Getting hash of a new commit.")
            .runSync()
            .printNotEmptyResultFields();
    childBranches.removeWhere((e) => e.name == rebaseTarget);
    if (childBranches.isNotEmpty) {
      // rebase
    }
    context.git.pushForce
        .announce("Force pushing to a remote.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
