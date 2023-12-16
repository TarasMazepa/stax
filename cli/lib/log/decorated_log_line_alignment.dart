import 'dart:math';

class DecoratedLogLineAlignment {
  final int branchName;
  final int decoration;

  DecoratedLogLineAlignment(this.branchName, this.decoration);

  DecoratedLogLineAlignment operator +(DecoratedLogLineAlignment other) {
    return DecoratedLogLineAlignment(
      max(branchName, other.branchName),
      max(decoration, other.decoration),
    );
  }
}
