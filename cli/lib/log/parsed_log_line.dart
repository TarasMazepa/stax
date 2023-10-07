class ParsedLogLine {
  final Set<int> branchIndexes;
  final String pattern;
  final String commitHash;
  final String commitMessage;

  ParsedLogLine(this.pattern, this.commitHash, this.commitMessage)
      : branchIndexes = pattern.codeUnits.indexed
            .where((e) => e.$2 != " ".codeUnits[0])
            .map((e) => e.$1)
            .toSet();

  factory ParsedLogLine.parse(String line) {
    final leftBracketIndex = line.indexOf("[");
    final rightBracketIndex = line.indexOf("]");
    return ParsedLogLine(
      line.substring(0, leftBracketIndex - 1),
      line.substring(leftBracketIndex + 1, rightBracketIndex),
      line.substring(rightBracketIndex + 2),
    );
  }

  bool containsAllBranches(ParsedLogLine other) {
    return branchIndexes.containsAll(other.branchIndexes);
  }

  @override
  String toString() {
    return "$pattern $commitHash $commitMessage";
  }
}
