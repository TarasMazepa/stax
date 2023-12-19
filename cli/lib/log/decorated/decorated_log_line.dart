import 'package:stax/log/decorated/decorated_log_line_alignment.dart';

class DecoratedLogLine {
  final String branchName;
  final String decoration;

  DecoratedLogLine(this.branchName, this.decoration);

  DecoratedLogLine withIndent(String indent) {
    return DecoratedLogLine(branchName, indent + decoration);
  }

  DecoratedLogLineAlignment getAlignment() {
    return DecoratedLogLineAlignment(branchName.length, decoration.length);
  }

  String decorateToString(DecoratedLogLineAlignment alignment) {
    String align(String field, int size) {
      return field + (" " * (size - field.length));
    }

    return "${align(decoration, alignment.decoration)} "
        "${align(branchName, alignment.branchName)}";
  }

  @override
  String toString() {
    return "$decoration $branchName";
  }
}
