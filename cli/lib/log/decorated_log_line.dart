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

  DecoratedLogLineAlignment getAlignment() {
    return DecoratedLogLineAlignment(branchName.length, commitHash.length,
        commitMessage.length, decoration.length);
  }

  String decorateToString(
    DecoratedLogLineAlignment alignment, {
    bool includeCommitHash = true,
    bool includeCommitMessage = true,
    bool includeBranchName = true,
  }) {
    String align(String field, int size) {
      return field + (" " * (size - field.length));
    }

    return "${align(decoration, alignment.decoration)}"
        "${includeCommitHash ? " [${align(commitHash, alignment.commitHash)}]" : ""}"
        "${includeBranchName ? " ${align(branchName, alignment.branchName)}" : ""}"
        "${includeCommitMessage ? " $commitMessage" : ""}";
  }

  @override
  String toString() {
    return "$decoration $branchName [$commitHash] $commitMessage";
  }
}
