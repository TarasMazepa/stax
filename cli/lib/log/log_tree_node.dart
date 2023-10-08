import 'package:collection/collection.dart';
import 'package:stax/log/decorated_log_line.dart';
import 'package:stax/log/parsed_log_line.dart';

class LogTreeNode {
  LogTreeNode? parent;
  final List<LogTreeNode> children;
  final ParsedLogLine line;
  final String branchName;

  LogTreeNode(this.line, this.branchName, this.children) {
    for (var child in children) {
      child.parent = this;
    }
    sortChildren();
  }

  void sortChildren() {
    children.sort((a, b) => b.length() - a.length());
  }

  int length() {
    return switch (children.length) {
      0 => 1,
      _ => children.map((e) => e.length()).max + 1,
    };
  }

  void collapse() {
    if (children.isEmpty) return;
    final parent = this.parent;
    if (parent != null &&
        children.length == 1 &&
        branchName == children[0].branchName) {
      final child = children[0];
      child.parent = parent;
      parent.children.remove(this);
      parent.children.add(child);
      child.collapse();
      parent.sortChildren();
      return;
    }
    for (var child in children) {
      child.collapse();
    }
  }

  DecoratedLogLine toDecorated() {
    return DecoratedLogLine(
        branchName, line.commitHash, line.commitMessage, "*");
  }

  List<DecoratedLogLine> toDecoratedList({int indent = 0}) {
    return children
        .expandIndexed((i, e) =>
            e.toDecoratedList().map((e) => e.withIndent("| " * (i + indent))))
        .followedBy([
      toDecorated().withExtend("-┘" * (children.length - 1 + indent))
    ]).toList();
  }

  @override
  String toString() {
    return "$branchName $line [${children.join(", ")}]";
  }
}
