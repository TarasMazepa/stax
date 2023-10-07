import 'package:stax/log/parsed_log_line.dart';

class LogTreeNode {
  LogTreeNode? parent;
  List<LogTreeNode> children = List.empty(growable: true);
  ParsedLogLine line;
  String branchName;

  LogTreeNode(this.line, this.branchName);

  void addChild(LogTreeNode other) {
    other.parent = this;
    children.add(other);
  }

  void addChildren(List<LogTreeNode> children) {
    for (var child in children) {
      addChild(child);
    }
  }

  void addParent(LogTreeNode other) {
    other.addChild(this);
  }

  @override
  String toString() {
    return "$branchName $line [${children.join(", ")}]";
  }
}
