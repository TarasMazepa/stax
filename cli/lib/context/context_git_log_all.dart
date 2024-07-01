import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';

extension GitLogAllOnContext on Context {
  GitLogAllNode gitLogAll() {
    final lines = git.log
        .args([
          "--decorate=full",
          "--format=%h %ct %p %(decorate:prefix=,suffix=,tag=tag>,separator= ,pointer=>)",
          "--all",
        ])
        .runSync()
        .stdout
        .toString()
        .split("\n")
        .where((x) => x.isNotEmpty)
        .map((x) => GitLogAllLine.parse(x))
        .toList()
        .reversed
        .toList();
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
  final String commitHash;
  final int timestamp;
  final String? parentCommitHash;
  final List<String> parts;

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
      parts.length >= 3
          ? parts.sublist(3).whereNot((x) => x.startsWith("tag>")).toList()
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

  GitLogAllNode collapse() {
    children = children.map((x) => x.collapse()).toList();
    if (line.parts.isEmpty && children.length == 1) {
      children.first.parent = parent;
      return children.first;
    }
    return this;
  }

  List<String> describe() {
    return [...children.expand((x) => x.describe()), toString()];
  }

  bool isHead() {
    return line.parts.any((x) => x.startsWith("HEAD>"));
  }

  @override
  String toString() {
    return "${line.commitHash} ${line.timestamp}"
        "${parent?.line.commitHash == null ? "" : " ${parent?.line.commitHash}"}"
        "${line.parts.isEmpty ? "" : " ${line.parts.join(" ")}"}";
  }
}
