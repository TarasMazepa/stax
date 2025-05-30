import 'package:collection/collection.dart';
import 'package:stax/log/decorated/decorated_log_line.dart';
import 'package:stax/log/decorated/map_to_string_on_list_of_decorated_log_lines.dart';

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
  final emptyIndent =
      (adapter.isDefaultBranch(root) &&
          children.isNotEmpty &&
          !adapter.isDefaultBranch(children.first))
      ? 1
      : 0;
  final point = adapter.isCurrent(root) ? 'x' : 'o';
  return children
      .expandIndexed(
        (i, e) => _produceDecoratedLogLine(
          e,
          adapter,
        ).map((e) => e.withIndent('  ' * emptyIndent + '| ' * i)),
      )
      .followedBy([
        DecoratedLogLine(
          adapter.branchName(root),
          "$point${"-┘" * (children.length - 1 + emptyIndent)}",
        ),
      ])
      .toList();
}

List<String> materializeDecoratedLogLines<T>(
  T root,
  DecoratedLogLineProducerAdapter<T> adapter,
) {
  return _produceDecoratedLogLine(root, adapter).mapToString().toList();
}
