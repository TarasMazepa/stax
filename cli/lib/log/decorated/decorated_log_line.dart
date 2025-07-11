import 'dart:math';

import 'package:stax/log/decorated/decorated_log_line_alignment.dart';

class DecoratedLogLine {
  final String branchName;
  final String decoration;

  DecoratedLogLine(this.branchName, this.decoration);

  DecoratedLogLine withIndent(String indent) {
    return DecoratedLogLine(branchName, indent + decoration);
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
