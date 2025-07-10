import 'package:collection/collection.dart';
import 'package:stax/log/decorated/decorated_log_line.dart';
import 'package:stax/log/decorated/decorated_log_line_alignment.dart';

abstract class DecoratedLogLineProducerAdapter<T> {
  List<T> children(T t);

  bool isDefaultBranch(T t);

  String branchName(T t);

  bool isCurrent(T t);
}

Iterable<DecoratedLogLine> _produceDecoratedLogLine<T>(
  T root,
  DecoratedLogLineProducerAdapter<T> adapter,
) {
  final children = adapter.children(root);
  final emptyIndentLength =
      (adapter.isDefaultBranch(root) &&
          children.isNotEmpty &&
          !adapter.isDefaultBranch(children.first))
      ? 1
      : 0;
  late final emptyIndent = '  ' * emptyIndentLength;
  final point = adapter.isCurrent(root) ? 'x' : 'o';
  return children
      .expandIndexed(
        (i, e) => _produceDecoratedLogLine(
          e,
          adapter,
        ).map((e) => e.withIndent(emptyIndent + '| ' * i)),
      )
      .followedBy([
        DecoratedLogLine(
          adapter.branchName(root),
          "$point${"-┘" * (children.length - 1 + emptyIndentLength)}",
        ),
      ]);
}

String materializeDecoratedLogLines<T>(
  T root,
  DecoratedLogLineProducerAdapter<T> adapter,
) {
  final decoratedLogLines = _produceDecoratedLogLine(
    root,
    adapter,
  ).toList(growable: false);
  final alignment = decoratedLogLines.fold(
    DecoratedLogLineAlignment.zero(),
    (alignment, element) => element.getMaxAlignment(alignment),
  );
  final buffer = StringBuffer();
  bool beyondFirst = false;
  for (var line in decoratedLogLines) {
    if (beyondFirst) {
      buffer.writeln();
    } else {
      beyondFirst = true;
    }
    line.decorateToStringBuffer(alignment, buffer);
  }
  return buffer.toString();
}
