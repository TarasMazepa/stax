import 'dart:math';

class DecoratedLogLineAlignment {
  final int branchName;
  final int decoration;
  final bool branchNameHasBrackets;

  DecoratedLogLineAlignment(
      this.branchName, this.decoration, this.branchNameHasBrackets);

  DecoratedLogLineAlignment operator +(DecoratedLogLineAlignment other) {
    return DecoratedLogLineAlignment(
      max(branchName, other.branchName),
      max(decoration, other.decoration),
      branchNameHasBrackets || other.branchNameHasBrackets,
    );
  }
}
