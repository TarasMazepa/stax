class LogEntry {
  final int branch;

  LogEntry(this.branch);

  @override
  String toString() {
    return "$branch";
  }
}
