import 'package:stax/log/parsed_log_line.dart';

class TreeNode<T> {
  TreeNode<T>? parent;
  List<TreeNode<T>> children = List.empty(growable: true);
  T data;
  ParsedLogLine line;

  TreeNode(this.data, this.line);

  void addChild(TreeNode<T> other) {
    other.parent = this;
    children.add(other);
  }

  void addChildren(List<TreeNode<T>> children) {
    for (var child in children) {
      addChild(child);
    }
  }

  void addParent(TreeNode<T> other) {
    other.addChild(this);
  }

  @override
  String toString() {
    return "$data $line [${children.join(", ")}]";
  }
}
