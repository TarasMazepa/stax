import 'package:collection/collection.dart';
import 'package:stax/comparison_chain.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';
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
    final quiet = withQuiet(true);
    Iterable<List<GitLogAllLine>> generateLines() sync* {
      int skip = 0;
      while (true) {
        final result = git.log
            .args([
              '--decorate=full',
              '--format=%h %ct %p %d',
              '--all',
              if (skip > 0) '--skip=$skip',
            ])
            .announce()
            .runSync()
            .printNotEmptyResultFields()
            .stdout
            .toString()
            .split('\n')
            .where((x) => x.isNotEmpty)
            .map((x) => GitLogAllLine.parse(x))
            .toList();
        if (result.isEmpty) return;
        yield result;
        if (result.last.parentCommitHash == null) return;
        skip += result.length;
      }
    }

    List<GitLogAllLine> lines = generateLines().flattenedToList.reversed
        .toList();
    final roots = lines
        .where((x) => x.parentCommitHash == null)
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
      quiet.printToConsole(
        'Tree building for log with ${lines.length} commits',
      );
      if (lines.length == oldLength) {
        quiet.printToConsole('Omitting $oldLength nodes');
        break;
      }
      oldLength = lines.length;
      for (final line in lines) {
        final parent = nodes[line.parentCommitHash];
        if (parent == null) {
          nextLines.add(line);
          continue;
        }
        final node = parent.addChild(line);
        nodes[node.line.commitHash] = node;
      }
      (lines, nextLines) = (nextLines, []);
    }
    return roots;
  }
}

class GitLogAllLine {
  final String commitHash;
  final int timestamp;
  final String? parentCommitHash;
  final List<String> parts;
  late final bool partsHasRemoteHead = parts.any(
    (x) => x.startsWith('refs/remotes/') && x.endsWith('/HEAD'),
  );
  late final bool partsHasRemoteRef = parts.any(
    (x) => x.startsWith('refs/remotes/'),
  );
  late final bool isCurrent = parts.any(
    (x) => x.startsWith('HEAD -> ') || x == 'HEAD',
  );

  GitLogAllLine(
    this.commitHash,
    this.timestamp,
    this.parentCommitHash,
    this.parts,
  );

  factory GitLogAllLine.parse(String line) {
    final parts = line.split('  ').where((x) => x.isNotEmpty).toList();
    final firstParts = parts[0].split(' ').where((x) => x.isNotEmpty).toList();
    return GitLogAllLine(
      firstParts.first,
      int.parse(firstParts[1]),
      firstParts.elementAtOrNull(2),
      parts.length > 1
          ? parts.last
                .replaceAll('(', '')
                .replaceAll(')', '')
                .split(', ')
                .map((x) => x.trim())
                .where((x) => x.isNotEmpty)
                .whereNot((x) => x.startsWith('tag: '))
                .toList()
          : [],
    );
  }

  Iterable<String> remoteBranchNames() {
    return parts
        .where((x) => x.startsWith('refs/remotes/'))
        .map((x) => x.replaceFirst('refs/remotes/', ''));
  }

  Iterable<String> localBranchNamesAndHead() {
    return parts
        .map((x) => x.replaceFirst('HEAD -> ', ''))
        .where((x) => x.startsWith('refs/heads/') || x == 'HEAD')
        .map((x) => x.replaceFirst('refs/heads/', ''));
  }

  Iterable<String> localBranchNames() {
    return localBranchNamesAndHead().whereNot((x) => x == 'HEAD');
  }

  String? branchName() {
    return localBranchNames().followedBy(remoteBranchNames()).firstOrNull;
  }

  String branchNameOrCommitHash() {
    return branchName() ?? commitHash;
  }

  @override
  String toString() {
    return "'$commitHash' '$timestamp'"
        "${parentCommitHash == null ? "" : " '$parentCommitHash'"}"
        "${parts.isEmpty ? "" : " ${parts.map((x) => "'$x'").join(" ")}"}";
  }
}

class GitLogAllNode {
  final GitLogAllLine line;
  GitLogAllNode? parent;
  List<GitLogAllNode> children = [];

  List<GitLogAllNode> get sortedChildren {
    return children.sorted(
      (a, b) => ComparisonChain()
          .chainBoolReverse(
            a.isRemoteHeadReachable(),
            b.isRemoteHeadReachable(),
          )
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
      line.parentCommitHash == null,
      'To create root node line.parentCommitHash should be null',
    );
    return GitLogAllNode(line, null);
  }

  GitLogAllNode(this.line, this.parent);

  GitLogAllNode addChild(GitLogAllLine line) {
    children.add(GitLogAllNode(line, this));
    return children.last;
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
    return t.children.sorted(
      (a, b) => ComparisonChain()
          .chainBoolReverse(isDefaultBranch(a), isDefaultBranch(b))
          .chain(
            () => (b.line.branchNameOrCommitHash()).compareTo(
              a.line.branchNameOrCommitHash(),
            ),
          )
          .chain(() => b.line.timestamp - a.line.timestamp)
          .compare(),
    );
  }

  @override
  bool isCurrent(GitLogAllNode t) {
    return t.line.isCurrent;
  }

  @override
  bool isDefaultBranch(GitLogAllNode t) {
    return (t.line.partsHasRemoteHead ||
            (defaultBranch != null &&
                t.line.parts.any((x) => x.endsWith(defaultBranch!)))) ||
        t.children.any((x) => isDefaultBranch(x));
  }
}
