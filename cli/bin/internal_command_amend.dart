import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_child_branches.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_handle_add_all_argument.dart';

import 'internal_command.dart';

class InternalCommandAmend extends InternalCommand {
  InternalCommandAmend() : super("amend", "Amends and pushes changes.");

  @override
  void run(final List<String> args, final Context context) {
    context.handleAddAllArgument(args);
    if (context.isThereNoStagedChanges()) {
      context.printToConsole("Can't amend - there is nothing staged. "
          "Run 'git add .' to add all the changes.");
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
    childBranches.remove(rebaseTarget);
    if (childBranches.isNotEmpty) {
      // rebase
    }
    context.git.pushForce
        .announce("Force pushing to a remote.")
        .runSync()
        .printNotEmptyResultFields();
  }
}
