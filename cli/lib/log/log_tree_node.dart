import 'package:collection/collection.dart';
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
    children.sort((a, b) => b.length() - a.length());
  }

  int length() {
    return switch (children.length) {
      0 => 1,
      _ => children.map((e) => e.length()).max + 1,
    };
  }

  List<String> decorate() {
    return children
        .expandIndexed((i, e) => e.decorate().map((e) => "| " * i + e))
        .followedBy(["*${"-┘" * (children.length - 1)}"]).toList();
  }

  @override
  String toString() {
    return "$branchName $line [${children.join(", ")}]";
  }
}
