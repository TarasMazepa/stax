import 'dart:math';

import 'package:stax/code_units.dart';
import 'package:stax/log/decorated/decorated_log_line_alignment.dart';

class DecoratedLogLine {
  final String branchName;
  final String decoration;
  late final bool branchNameHasBrackets =
      branchName.codeUnits.firstOrNull == CodeUnits.leftSquareBracket &&
      branchName.codeUnits.lastOrNull == CodeUnits.rightSquareBracket;

  DecoratedLogLine(this.branchName, this.decoration);

  DecoratedLogLine withIndent(String indent) {
    return DecoratedLogLine(branchName, indent + decoration);
  }

  DecoratedLogLineAlignment getMaxAlignment(
    DecoratedLogLineAlignment alignment,
  ) {
    if (alignment.branchNameLength < branchName.length ||
        alignment.decorationLength < decoration.length) {
      return DecoratedLogLineAlignment(
        max(branchName.length, alignment.branchNameLength),
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
      ..write(' ' * (alignment.decorationLength - decoration.length))
      ..write(' ')
      ..write(branchName);
  }

  @override
  String toString() {
    return '$decoration $branchName';
  }
}
