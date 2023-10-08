import 'package:stax/log/log_tree_node.dart';

extension LogTreePrint on Iterable<LogTreeNode> {
  String printedLogTree() {
    final lines = expand((e) => e.toDecoratedList(indent: 1)).toList();
    final alignment = lines
        .map((e) => e.getAlignment())
        .reduce((value, element) => value + element);
    return lines.map((e) => e.align(alignment)).join("\n");
  }
}
