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

  @override
  String toString() {
    return "$decoration $branchName [$commitHash] $commitMessage";
  }
}
