import 'package:collection/collection.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
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

  bool isDefaultBranch() {
    return branchName == ContextGitGetDefaultBranch.defaultBranch;
  }

  void sortChildren() {
    children.sort((a, b) => b.sortingValue() - a.sortingValue());
  }

  int sortingValue() {
    return length() + (isDefaultBranch() ? 1000000 : 0);
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

  @override
  String toString() {
    return "$branchName [${children.join(", ")}]";
  }
}
