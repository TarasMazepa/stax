import 'package:stax/log/parsed_log_line.dart';

class TreeNode {
  TreeNode? parent;
  List<TreeNode> children = List.empty(growable: true);
  ParsedLogLine line;
  int branchLocalIndex;

  TreeNode(this.line, this.branchLocalIndex);

  void addChild(TreeNode other) {
    other.parent = this;
    children.add(other);
  }

  void addChildren(List<TreeNode> children) {
    for (var child in children) {
      addChild(child);
    }
  }

  void addParent(TreeNode other) {
    other.addChild(this);
  }

  @override
  String toString() {
    return "$branchLocalIndex $line [${children.join(", ")}]";
  }
}
