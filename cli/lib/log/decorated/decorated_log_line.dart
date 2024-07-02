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
    String result = "";
    result += decoration;
    result += " " * (alignment.decoration - decoration.length);
    result += " ";
    if (alignment.branchNameHasBrackets && !branchNameHasBrackets) {
      result += " $branchName";
    } else {
      result += branchName;
    }
    return result;
  }

  @override
  String toString() {
    return "$decoration $branchName";
  }
}
