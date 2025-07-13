import 'package:collection/collection.dart';
import 'package:stax/comparison_chain.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';
import 'package:stax/log/git_log_all_line.dart';
import 'package:stax/rebase/rebase_step.dart';

extension GitLogAllOnContext on Context {
  static GitLogAllNode? _gitLogAllLocal;
  static GitLogAllNode? _gitLogAllAll;

  GitLogAllNode gitLogAll([bool showAllBranches = false]) {
    produce() => withQuiet(
      true,
    )._gitLogAll().map((x) => x.collapse(showAllBranches)).nonNulls.first;
    if (showAllBranches) {
      return _gitLogAllAll ??= produce();
    }
    return _gitLogAllLocal ??= produce();
  }

  List<GitLogAllNode> _gitLogAll() {
    List<GitLogAllLine> lines = git.log
        .args(['--decorate=full', '--format=%h %ct %p %d', '--all'])
        .announce()
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split('\n')
        .where((x) => x.isNotEmpty)
        .map((x) => GitLogAllLine.parse(x))
        .toList()
        .reversed
        .toList();
    final roots = lines
        .where((x) => x.parentsCommitHashes.isEmpty)
        .map((x) => GitLogAllNode.root(x))
        .toList();
    final nodes = <String, GitLogAllNode>{};
    for (final root in roots) {
      lines.remove(root.line);
      nodes[root.line.commitHash] = root;
    }
    List<GitLogAllLine> nextLines = [];
    int oldLength = 0;
    while (lines.isNotEmpty) {
      printToConsole('Tree building for log with ${lines.length} commits');
      if (lines.length == oldLength) {
        printToConsole('Omitting $oldLength nodes');
        break;
      }
      oldLength = lines.length;
      for (final line in lines) {
        final parent = nodes[line.parentCommitHash];
        if (parent == null) {
          nextLines.add(line);
          continue;
        }
        final node = GitLogAllNode(line);
        parent.addChildNode(node);
        nodes[node.line.commitHash] = node;
      }
      (lines, nextLines) = (nextLines, []);
    }
    return roots;
  }
}

class GitLogAllNode {
  final GitLogAllLine line;
  GitLogAllNode? parent;
  List<GitLogAllNode> children = [];

  List<GitLogAllNode> get sortedChildren {
    return getSortedChildren((x) => x.isRemoteHeadReachable());
  }

  List<GitLogAllNode> getSortedChildren(
    bool Function(GitLogAllNode) isPartOfMainBranch,
  ) {
    return children.sorted(
      (a, b) => ComparisonChain()
          .chainBoolReverse(isPartOfMainBranch(a), isPartOfMainBranch(b))
          .chain(
            () => (b.line.branchNameOrCommitHash()).compareTo(
              a.line.branchNameOrCommitHash(),
            ),
          )
          .chain(() => b.line.timestamp - a.line.timestamp)
          .compare(),
    );
  }

  factory GitLogAllNode.root(GitLogAllLine line) {
    assert(
      line.parentsCommitHashes.isEmpty,
      'To create root node line.parentsCommitHashes should be empty',
    );
    return GitLogAllNode(line);
  }

  GitLogAllNode(this.line, [this.parent]);

  GitLogAllNode addChildNode(GitLogAllNode node) {
    children.add(node);
    return node;
  }

  GitLogAllNode? collapse([bool showAllBranches = false, int depth = 1000]) {
    if (depth < 0) return this;
    List<GitLogAllNode> newChildren = [];
    for (int i = 0; i < children.length; i++) {
      GitLogAllNode? child, newChild = children[i];
      while (newChild != null && child != newChild) {
        child = newChild;
        newChild = child.collapse(showAllBranches, depth - 1);
      }
      if (newChild == null) continue;
      newChildren.add(newChild);
    }
    children = newChildren;
    final hasInterestingParts =
        (showAllBranches && line.partsHasRemoteRef) ||
        line.partsHasRemoteHead ||
        line.parts.any(
          (x) =>
              x.startsWith('refs/heads/') ||
              x.startsWith('HEAD -> refs/heads/') ||
              x == 'HEAD',
        );
    if (!hasInterestingParts && children.length == 1) {
      children.first.parent = parent;
      return children.first;
    }
    if (!hasInterestingParts && children.isEmpty) {
      return null;
    }
    return this;
  }

  List<String> describe() {
    return [...children.expand((x) => x.describe()), toString()];
  }

  GitLogAllNode? findAnyRefThatEndsWith(String suffix) {
    return find((x) => x.line.parts.any((element) => element.endsWith(suffix)));
  }

  GitLogAllNode? find(bool Function(GitLogAllNode) predicate) {
    if (predicate(this)) return this;
    return children.map((x) => x.find(predicate)).nonNulls.firstOrNull;
  }

  GitLogAllNode? findCurrent() {
    return find((x) => x.line.isCurrent);
  }

  GitLogAllNode? findRemoteHead() {
    return find((x) => x.line.partsHasRemoteHead);
  }

  Iterable<RebaseStep> localBranchNamesInOrderForRebase() {
    return [
      RebaseStep(
        line.localBranchNames().first,
        parent?.line.localBranchNames().firstOrNull ??
            parent?.line.remoteBranchNames().firstOrNull,
      ),
    ].followedBy(children.expand((x) => x.localBranchNamesInOrderForRebase()));
  }

  Iterable<String> remoteBranchNamesInOrderForCheckout() {
    return children
        .expand((x) => x.remoteBranchNamesInOrderForCheckout())
        .cast<String?>()
        .followedBy([line.remoteBranchNames().firstOrNull])
        .nonNulls;
  }

  bool isRemoteHeadReachable() {
    return line.partsHasRemoteHead ||
        children.any((x) => x.isRemoteHeadReachable());
  }

  @override
  String toString() {
    return '${line.commitHash} ${line.timestamp}'
        "${parent?.line.commitHash == null ? "" : " ${parent?.line.commitHash}"}"
        "${line.parts.isEmpty ? "" : " ${line.parts.join(" ")}"}";
  }
}

class DecoratedLogLineProducerAdapterForGitLogAllNode
    implements DecoratedLogLineProducerAdapter<GitLogAllNode> {
  final String? defaultBranch;
  final bool showAllBranches;

  DecoratedLogLineProducerAdapterForGitLogAllNode(
    this.showAllBranches, [
    this.defaultBranch,
  ]);

  @override
  String branchName(GitLogAllNode t) {
    return [
      if (showAllBranches || t.line.partsHasRemoteHead)
        ...t.line.remoteBranchNames(),
      ...t.line.localBranchNamesAndHead(),
    ].join(', ');
  }

  @override
  List<GitLogAllNode> children(GitLogAllNode t) {
    return t.getSortedChildren((x) => isDefaultBranch(x));
  }

  @override
  bool isCurrent(GitLogAllNode t) {
    return t.line.isCurrent;
  }

  @override
  bool isDefaultBranch(GitLogAllNode t) {
    final defaultBranch = this.defaultBranch;
    return (t.line.partsHasRemoteHead ||
            (defaultBranch != null &&
                t.line.parts.any((x) => x.endsWith(defaultBranch)))) ||
        t.children.any((x) => isDefaultBranch(x));
  }
}
