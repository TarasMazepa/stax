import 'package:stax/log/decorated/decorated_log_line_producer.dart';
import 'package:stax/log/log_tree_node.dart';

class DecoratedLogLineProducerAdapterForLogTreeNode
    implements DecoratedLogLineProducerAdapter<LogTreeNode> {
  @override
  String branchName(LogTreeNode t) {
    return t.branchName;
  }

  @override
  List<LogTreeNode> children(LogTreeNode t) {
    return t.children;
  }

  @override
  bool isDefaultBranch(LogTreeNode t) {
    return t.isDefaultBranch();
  }

  @override
  bool isCurrent(LogTreeNode t) {
    return false;
  }
}
