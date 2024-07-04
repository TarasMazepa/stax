import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

extension GitLogAllOnContext on Context {
  GitLogAllNode gitLogAll() {
    final lines = git.log
        .args([
          "--decorate=full",
          "--format=%h %ct %p %(decorate:tag=tag>,separator=|,pointer=>)",
          "--all",
        ])
        .runSync()
        .stdout
        .toString()
        .split("\n")
        .where((x) => x.isNotEmpty)
        .map((x) => GitLogAllLine.parse(x))
        .sorted((a, b) {
          if (a.parentCommitHash == null) {
            if (b.parentCommitHash == null) {
              return a.timestamp - b.timestamp;
            }
            return -1;
          }
          if (b.parentCommitHash == null) {
            return 1;
          }
          return a.timestamp - b.timestamp;
        });
    int i = 0;
    final root = GitLogAllNode.root(lines[0]);
    final nodes = {root.line.commitHash: root};
    for (; i < lines.length; i++) {
      final line = lines[i];
      final parent = nodes[line.parentCommitHash];
      if (parent == null) continue;
      final node = parent.addChild(line);
      nodes[node.line.commitHash] = node;
    }
    return root;
  }
}

class GitLogAllLine {
  static final remoteHeadPattern = RegExp(r"^refs/remotes/.+/HEAD$");

  final String commitHash;
  final int timestamp;
  final String? parentCommitHash;
  final List<String> parts;
  late final bool partsHasRemoteHead =
      parts.any((x) => remoteHeadPattern.matchAsPrefix(x) != null);

  GitLogAllLine(
    this.commitHash,
    this.timestamp,
    this.parentCommitHash,
    this.parts,
  );

  factory GitLogAllLine.parse(String line) {
    final parts = line.split(" ").where((x) => x.isNotEmpty).toList();
    return GitLogAllLine(
      parts.first,
      int.parse(parts[1]),
      parts.elementAtOrNull(2),
      parts.last[0] == '('
          ? parts.last
              .replaceAll("(", "")
              .replaceAll(")", "")
              .split("|")
              .whereNot((x) => x.startsWith("tag>"))
              .toList()
          : [],
    );
  }

  @override
  String toString() {
    return "$commitHash $timestamp"
        "${parentCommitHash == null ? "" : " $parentCommitHash"}"
        "${parts.isEmpty ? "" : " ${parts.join(" ")}"}";
  }
}

class GitLogAllNode {
  final GitLogAllLine line;
  GitLogAllNode? parent;
  List<GitLogAllNode> children = [];

  factory GitLogAllNode.root(GitLogAllLine line) {
    assert(line.parentCommitHash == null,
        "To create root node line.parentCommitHash should be null");
    return GitLogAllNode(line, null);
  }

  GitLogAllNode(this.line, this.parent);

  GitLogAllNode addChild(GitLogAllLine line) {
    children.add(GitLogAllNode(line, this));
    return children.last;
  }

  GitLogAllNode? collapse() {
    children = children.map((x) => x.collapse()).whereNotNull().toList();
    final hasInterestingParts = line.partsHasRemoteHead ||
        line.parts.any((x) =>
            x.startsWith("refs/heads/") || x.startsWith("HEAD>refs/heads/"));
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

  @override
  String toString() {
    return "${line.commitHash} ${line.timestamp}"
        "${parent?.line.commitHash == null ? "" : " ${parent?.line.commitHash}"}"
        "${line.parts.isEmpty ? "" : " ${line.parts.join(" ")}"}";
  }
}

class DecoratedLogLineProducerAdapterForGitLogAllNode
    implements DecoratedLogLineProducerAdapter<GitLogAllNode> {
  final String? defaultBranch;

  DecoratedLogLineProducerAdapterForGitLogAllNode([this.defaultBranch]);

  @override
  String branchName(GitLogAllNode t) {
    return [
      if (t.line.partsHasRemoteHead)
        ...t.line.parts
            .where((x) => x.startsWith("refs/remotes/"))
            .map((x) => x.replaceFirst("refs/remotes/", "")),
      ...t.line.parts
          .map((x) => x.replaceFirst("HEAD>", ""))
          .where((x) => x.startsWith("refs/heads/"))
          .map((x) => x.replaceFirst("refs/heads/", ""))
    ].join(", ");
  }

  @override
  List<GitLogAllNode> children(GitLogAllNode t) {
    return t.children.sorted((a, b) {
      if (isDefaultBranch(a)) {
        if (isDefaultBranch(b)) {
          return a.line.timestamp - b.line.timestamp;
        }
        return -1;
      }
      if (isDefaultBranch(b)) {
        return 1;
      }
      return a.line.timestamp - b.line.timestamp;
    });
  }

  @override
  bool isCurrent(GitLogAllNode t) {
    return t.line.parts.any((x) => x.startsWith("HEAD>"));
  }

  @override
  bool isDefaultBranch(GitLogAllNode t) {
    return (t.line.partsHasRemoteHead ||
            (defaultBranch != null &&
                t.line.parts.any((x) => x.endsWith(defaultBranch!)))) ||
        t.children.any((x) => isDefaultBranch(x));
  }
}
