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

  DecoratedLogLineAlignment getAlignment() {
    return DecoratedLogLineAlignment(
      branchName.length,
      decoration.length,
      branchNameHasBrackets,
    );
  }

  String decorateToString(DecoratedLogLineAlignment alignment) {
    final result = StringBuffer();
    decorateToStringBuffer(alignment, result);
    return result.toString();
  }

  void decorateToStringBuffer(
    DecoratedLogLineAlignment alignment,
    StringBuffer buffer,
  ) {
    buffer
      ..write(decoration)
      ..write(' ' * (alignment.decorationLength - decoration.length))
      ..write(' ');
    if (alignment.branchNameHasBrackets && !branchNameHasBrackets) {
      buffer.write(' $branchName');
    } else {
      buffer.write(branchName);
    }
  }

  @override
  String toString() {
    return '$decoration $branchName';
  }
}
