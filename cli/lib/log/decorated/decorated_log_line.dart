import 'dart:math';

import 'package:stax/log/decorated/decorated_log_line_alignment.dart';

class DecoratedLogLine {
  final String branchName;
  final List<String> decorations;
  String? _decoration;

  String get decoration {
    return _decoration ??= (StringBuffer()..writeAll(decorations.reversed))
        .toString();
  }

  DecoratedLogLine(this.branchName, this.decorations);

  DecoratedLogLine withIndent(String indent) {
    decorations.add(indent);
    _decoration = null;
    return this;
  }

  DecoratedLogLineAlignment getMaxAlignment(
    DecoratedLogLineAlignment alignment,
  ) {
    if (alignment.decorationLength < decoration.length) {
      return DecoratedLogLineAlignment(
        max(decoration.length, alignment.decorationLength),
      );
    }
    return alignment;
  }

  void decorateToStringBuffer(
    DecoratedLogLineAlignment alignment,
    StringBuffer buffer,
  ) {
    buffer
      ..write(decoration)
      ..write(' ' * (alignment.decorationLength - decoration.length + 1))
      ..write(branchName);
  }

  @override
  String toString() {
    return '$decoration $branchName';
  }
}
