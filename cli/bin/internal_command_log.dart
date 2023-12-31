import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_all_branches.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_log_one_line_no_decorate_single_branch.dart';
import 'package:stax/log/log_tree_node.dart';
import 'package:stax/log/parsed_log_line.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  static final String collapseFlag = "--collapse";
  static final String branchesFlag = "--branches";

  InternalCommandLog()
      : super("log", "Builds a tree of all branches.", flags: {
          collapseFlag:
              "Collapses commits that are not heads of branches and only have one child commit.",
          branchesFlag:
              "Hides commit hashes and messages leaves you with branches only. "
                  "You can still see multiple occurrences of a single branch in a tree. "
                  "Using this flag automatically assumes --collapse flag too.",
        });

  @override
  void run(List<String> args, Context context) {
    /**
     * TODO:
     *  - Show/Hide commit hashes, messages
     *  - Sort connection groups
     */
    final onlyBranches = args.remove(branchesFlag);
    final collapse = args.remove(collapseFlag) || onlyBranches;
    context = context.withSilence(true);
    final defaultBranchName = context.getDefaultBranch();
    if (defaultBranchName == null) {
      return;
    }
    final defaultBranchCommits =
        context.logOneLineNoDecorateSingleBranch(defaultBranchName);
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
        final commit = defaultBranchCommits.firstWhere(
            (element) => commitToBranches.key.startsWith(element.hash));
        return LogTreeNode(
          ParsedLogLine("", commit.hash, commit.message),
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
    ).toList();
    final topCommit = defaultBranchCommits.first;
    if (connectionGroups
            .firstWhereOrNull((e) => e.line.commitHash == topCommit.hash) ==
        null) {
      connectionGroups.add(LogTreeNode(
          ParsedLogLine("", topCommit.hash, topCommit.message),
          defaultBranchName, []));
    }
    connectionGroups.sort((a, b) => [a, b]
        .map((line) => defaultBranchCommits
            .indexWhere((e) => e.hash == line.line.commitHash))
        .reduce((v, e) => v - e));
    final node = connectionGroups.reduce((value, element) {
      element.children.add(value);
      element.sortChildren();
      return element;
    });
    if (collapse) {
      node.collapse();
    }
    final lines = node.toDecoratedList();
    final alignment = lines
        .map((e) => e.getAlignment())
        .reduce((value, element) => value + element);
    print(lines
        .map(
          (e) => e.decorateToString(
            alignment,
            includeCommitHash: !onlyBranches,
            includeCommitMessage: !onlyBranches,
          ),
        )
        .join("\n"));
  }
}
