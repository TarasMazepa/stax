class ParsedLogLine {
  final String pattern;
  final String commitHash;
  final String commitMessage;

  ParsedLogLine(this.pattern, this.commitHash, this.commitMessage);

  factory ParsedLogLine.parse(String line) {
    final leftBracketIndex = line.indexOf("[");
    final rightBracketIndex = line.indexOf("]");
    return ParsedLogLine(
      line.substring(0, leftBracketIndex - 1),
      line.substring(leftBracketIndex + 1, rightBracketIndex),
      line.substring(rightBracketIndex + 2),
    );
  }

  @override
  String toString() {
    return "$pattern $commitHash $commitMessage";
  }
}
