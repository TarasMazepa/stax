import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/git/extract_branch_names.dart';
import 'package:stax/git/prepare_branch_names_for_extraction.dart';

import 'internal_command.dart';

class InternalCommandAmend extends InternalCommand {
  InternalCommandAmend() : super("amend", "Amends and pushes changes.");

  @override
  void run(final List<String> args, final Context context) {
    if (context.git.diffCachedQuiet
            .announce("Checking if there staged changes.")
            .runSync()
            .exitCode ==
        0) {
      context.printToConsole("Can't amend - there is nothing staged. "
          "Run 'git add .' to add all the changes.");
      return;
    }
    final childBranches = context.git.branchContains
        .announce("Noting child branches that might need to be rebased.")
        .runSync()
        .printNotEmptyResultFields()
        .prepareBranchNameForExtraction()
        .extractBranchNames()
        .toList();
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
