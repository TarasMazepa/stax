
class LogEntry {
  final int branch;
  final String pattern;
  final String commitHash;
  final String commitMessage;

  LogEntry(this.branch, this.pattern, this.commitHash, this.commitMessage);

  @override
  String toString() {
    return "$branch $pattern $commitHash $commitMessage";
  }
}
