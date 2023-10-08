import 'package:stax/log/parsed_log_line.dart';

class LogTreeNode {
  LogTreeNode? parent;
  final List<LogTreeNode> children;
  final ParsedLogLine line;
  final String branchName;

  LogTreeNode(this.line, this.children, this.branchName) {
    for (var child in children) {
      child.parent = this;
    }
  }

  @override
  String toString() {
    return "$branchName $line [${children.join(", ")}]";
  }
}
