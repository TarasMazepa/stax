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
    context = context.withSilence(true);
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
        final shortCommit = context.git.revParseShort
            .arg(commitToBranches.key)
            .runSync()
            .stdout
            .toString()
            .trim();
        return LogTreeNode(
          ParsedLogLine("", shortCommit, ""),
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
    final lines =
        connectionGroups.expand((e) => e.toDecoratedList(indent: 1)).toList();
    final alignment = lines
        .map((e) => e.getAlignment())
        .reduce((value, element) => value + element);
    print(lines.map((e) => e.align(alignment)).join("\n"));
  }
}
