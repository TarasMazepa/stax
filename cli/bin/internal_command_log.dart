import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_all_branches.dart';
import 'package:stax/context/context_git_get_default_branch.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  InternalCommandLog() : super("log", "Builds a tree of all branches.");

  @override
  void run(List<String> args, Context context) {
    final defaultBranchName = context.getDefaultBranch();
    if (defaultBranchName == null) {
      return;
    }
    final allBranches = context.getAllBranches();
    final defaultBranch =
        allBranches.where((e) => e.name == defaultBranchName).firstOrNull;
    if (defaultBranch == null) {
      return;
    }
    allBranches.remove(defaultBranch);
    final connectionPoints = groupBy(
        allBranches,
        (branch) => context.git.mergeBase
            .args([defaultBranch.name, branch.name])
            .runSync()
            .stdout
            .toString()
            .trim());
    for (final pair in connectionPoints.entries) {
      context.git.showBranchSha1Name
          .args(pair.value.map((e) => e.name).toList())
          .announce()
          .runSync()
          .printNotEmptyResultFields();
    }
  }
}
