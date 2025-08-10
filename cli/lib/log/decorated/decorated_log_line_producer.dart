import 'dart:math';

import 'package:stax/log/decorated/decorated_log_line.dart';

abstract class DecoratedLogLineProducerAdapter<T> {
  List<T> children(T t);

  bool isDefaultBranch(T t);

  String branchName(T t);

  bool isCurrent(T t);
}

List<DecoratedLogLine> _produceDecoratedLogLine<T>({
  required T root,
  required DecoratedLogLineProducerAdapter<T> adapter,
  int depth = 0,
}) {
  if (depth > 5000) {
    return [
      DecoratedLogLine('...overflow...', ['...']),
    ];
  }
  final children = adapter.children(root);
  final emptyIndentLength =
      (adapter.isDefaultBranch(root) &&
          children.isNotEmpty &&
          !adapter.isDefaultBranch(children.first))
      ? 1
      : 0;
  final result = <DecoratedLogLine>[];
  for (int i = 0; i < children.length; i++) {
    result.addAll(
      _produceDecoratedLogLine(
            root: children[i],
            adapter: adapter,
            depth: depth + 1,
          )
          .map((e) => e.withIndent('  ' * emptyIndentLength + '| ' * i))
          .toList(growable: false),
    );
  }
  result.add(
    DecoratedLogLine(adapter.branchName(root), [
      "${adapter.isCurrent(root) ? 'x' : 'o'}${"-┘" * (children.length - 1 + emptyIndentLength)}",
    ]),
  );
  return result;
}

String materializeDecoratedLogLines<T>({
  required T root,
  required DecoratedLogLineProducerAdapter<T> adapter,
  int? limit,
}) {
  final decoratedLogLines = _produceDecoratedLogLine(
    root: root,
    adapter: adapter,
  ).take(limit ?? 100);
  int alignment = 0;
  for (final decoratedLogLine in decoratedLogLines) {
    alignment = max(alignment, decoratedLogLine.decoration.length);
  }
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
