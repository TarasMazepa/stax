class TreeNode<T> {
  TreeNode? parent;
  List<TreeNode> children = List.empty(growable: true);
  T data;

  TreeNode(this.data);

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
    return "$data [${children.join(", ")}]";
  }
}
