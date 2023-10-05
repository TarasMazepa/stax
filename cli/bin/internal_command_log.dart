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
      final numberOfBranches = pair.value.length;
      final output = context.git.showBranchSha1Name
          .args(pair.value.map((e) => e.name).toList())
          .announce()
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .split("\n")
          .skip(numberOfBranches + 1)
          .toList()
          .reversed
          .toList();
      output.toString()
    }
    /*

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