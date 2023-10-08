import 'dart:math';

class DecoratedLogLineAlignment {
  final int branchName;
  final int commitHash;
  final int commitMessage;
  final int decoration;

  DecoratedLogLineAlignment(
      this.branchName, this.commitHash, this.commitMessage, this.decoration);

  DecoratedLogLineAlignment operator +(DecoratedLogLineAlignment other) {
    return DecoratedLogLineAlignment(
      max(branchName, other.branchName),
      max(commitHash, other.commitHash),
      max(commitMessage, other.commitMessage),
      max(decoration, other.decoration),
    );
  }
}
