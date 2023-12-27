import 'package:collection/collection.dart';
import 'package:stax/log/decorated/decorated_log_line.dart';

abstract class DecoratedLogLineProducerAdapter<T> {
  List<T> children(T t);

  bool isDefaultBranch(T t);

  String branchName(T t);

  bool isCurrent(T t);
}

List<DecoratedLogLine> _produceDecoratedLogLine<T>(
  T root,
  DecoratedLogLineProducerAdapter<T> adapter,
) {
  final children = adapter.children(root);
  final emptyIndent = (adapter.isDefaultBranch(root) &&
          children.isNotEmpty &&
          !adapter.isDefaultBranch(children.first))
      ? 1
      : 0;
  final point = adapter.isCurrent(root) ? "x" : "o";
  return children
      .expandIndexed((i, e) => _produceDecoratedLogLine(e, adapter)
          .map((e) => e.withIndent("  " * emptyIndent + "| " * i)))
      .followedBy([
    DecoratedLogLine(
      adapter.branchName(root),
      "$point${"-┘" * (children.length - 1 + emptyIndent)}",
    )
  ]).toList();
}

List<String> materializeDecoratedLogLines<T>(
  T root,
  DecoratedLogLineProducerAdapter<T> adapter,
) {
  final lines = _produceDecoratedLogLine(root, adapter);
  final alignment = lines
      .map((e) => e.getAlignment())
      .reduce((value, element) => value + element);
  return lines.map((e) => e.decorateToString(alignment)).toList();
}
