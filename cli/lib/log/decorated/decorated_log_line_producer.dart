import 'package:collection/collection.dart';
import 'package:stax/log/decorated/decorated_log_line.dart';

abstract class DecoratedLogLineProducerAdapter<T> {
  List<T> children(T t);

  bool isDefaultBranch(T t);

  String branchName(T t);
}

List<DecoratedLogLine> produceDecoratedLogLine<T>(
  T root,
  DecoratedLogLineProducerAdapter<T> adapter,
) {
  final children = adapter.children(root);
  final emptyIndent = (adapter.isDefaultBranch(root) &&
          children.isNotEmpty &&
          !adapter.isDefaultBranch(children.first))
      ? 1
      : 0;
  return children
      .expandIndexed((i, e) => produceDecoratedLogLine(e, adapter)
          .map((e) => e.withIndent("  " * emptyIndent + "| " * i)))
      .followedBy([
    DecoratedLogLine(
      adapter.branchName(root),
      "*${"-┘" * (children.length - 1 + emptyIndent)}",
    )
  ]).toList();
}
