import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_all_branches.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/log/log_tree_node.dart';
import 'package:stax/log/parsed_log_line.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  InternalCommandLog() : super("log", "Builds a tree of all branches.");

  @override
  void run(List<String> args, Context context) {
    final defaultBranchName = context.getDefaultBranch();
    if (defaultBranchName == null) {
      return;
    }
    final connectionGroups = context
        .getAllBranches()
        .whereNot((e) => e.name == defaultBranchName)
        .groupListsBy((branch) => context.git.mergeBase
            .args([defaultBranchName, branch.name])
            .runSync()
            .stdout
            .toString()
            .trim())
        .entries
        .map(
      (commitToBranches) {
        final branches = commitToBranches.value;
        return LogTreeNode(
          ParsedLogLine("", commitToBranches.key, ""),
          defaultBranchName,
          context.git.showBranchSha1Name
              .args(branches.map((e) => e.name).toList())
              .announce()
              .runSync()
              .printNotEmptyResultFields()
              .stdout
              .toString()
              .trim()
              .split("\n")
              .skip(branches.length + 1)
              .map(ParsedLogLine.parse)
              .fold(
            <LogTreeNode>[],
            (nodes, line) => (groupBy(
              nodes,
              (node) => line.containsAllBranches(node.line),
            )..putIfAbsent(true, () => []))
                .entries
                .expand((group) => !group.key
                    ? group.value
                    : [
                        LogTreeNode(
                          line,
                          line.branchIndexes
                                  .where((index) => group.value.none((e) =>
                                      e.line.branchIndexes.contains(index)))
                                  .map((e) => branches[e].name)
                                  .firstOrNull ??
                              group.value.map((e) => e.branchName).first,
                          group.value,
                        )
                      ])
                .toList(),
          ),
        );
      },
    );

    print(connectionGroups);

    /*

| *
*-┘

| *
| | *
*-┘-┘

| *
| | *
| | | *
*-┘-┘-┘

| *
| | *
| | | *
| | | | *
*-┘-┘-┘-┘

! [a] a
 ! [b] b
  ! [c] c
   ! [d] d
    ! [e] e
     ! [f] f
      ! [g] ggg
-------
      + [c3b3d18] ggg
      + [f59daac] g
     ++ [7bc6c72] f
    +++ [600b013] e
   +    [7d220a8] d
  +++++ [d0b4d6c] c
 ++++++ [5681909] b
+++++++ [363497b] a

a [b [c [d e[f [g]]]]]

*  main [c3b3d18]: Some commit
| *   g [f59daac]: Commit g
| *   f [7bc6c72]: Commit f
| *   e [600b013]: Commit e
| | * d [7d220a8]: Commit d
| *-┘ c [d0b4d6c]: Commit c
| *   b [5681909]: Commit b
| *   a [363497b]: Commit a
*-┘     [c3b3d18]: Commit message

* main  [c3b3d18]: Some commit
| * g   [f59daac]: Commit g
| * f   [7bc6c72]: Commit f
| * e   [600b013]: Commit e
| | * d [7d220a8]: Commit d
| *-┘ c [d0b4d6c]: Commit c
| * b   [5681909]: Commit b
| * a   [363497b]: Commit a
*-┘     [c3b3d18]: Commit message

* main [c3b3d18]: Some commit
| * g [f59daac]: Commit g
| * f [7bc6c72]: Commit f
| * e [600b013]: Commit e
| | * d [7d220a8]: Commit d
| *-┘ c [d0b4d6c]: Commit c
| * b [5681909]: Commit b
| * a [363497b]: Commit a
*-┘ [c3b3d18]: Commit message

     */
  }
}
