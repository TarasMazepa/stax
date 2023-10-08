import 'package:stax/log/decorated_log_line_alignment.dart';

class DecoratedLogLine {
  final String branchName;
  final String commitHash;
  final String commitMessage;
  final String decoration;

  DecoratedLogLine(
      this.branchName, this.commitHash, this.commitMessage, this.decoration);

  DecoratedLogLine withIndent(String indent) {
    return DecoratedLogLine(
        branchName, commitHash, commitMessage, indent + decoration);
  }

  DecoratedLogLine withExtend(String extend) {
    return DecoratedLogLine(
        branchName, commitHash, commitMessage, decoration + extend);
  }

  DecoratedLogLineAlignment getAlignment() {
    return DecoratedLogLineAlignment(branchName.length, commitHash.length,
        commitMessage.length, decoration.length);
  }

  String align(DecoratedLogLineAlignment alignment) {
    String align(String field, int size) {
      return field + (" " * (size - field.length));
    }

    return "${align(decoration, alignment.decoration)} "
        "[${align(commitHash, alignment.commitHash)}] "
        "${align(branchName, alignment.branchName)} $commitMessage";
  }

  @override
  String toString() {
    return "$decoration $branchName [$commitHash] $commitMessage";
  }
}
