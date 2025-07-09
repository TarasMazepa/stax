import 'dart:math';

class DecoratedLogLineAlignment {
  final int branchNameLength;
  final int decorationLength;
  final bool branchNameHasBrackets;

  DecoratedLogLineAlignment(
    this.branchNameLength,
    this.decorationLength,
    this.branchNameHasBrackets,
  );

  DecoratedLogLineAlignment.zero() : this(0, 0, false);

  DecoratedLogLineAlignment operator +(DecoratedLogLineAlignment other) {
    return DecoratedLogLineAlignment(
      max(branchNameLength, other.branchNameLength),
      max(decorationLength, other.decorationLength),
      branchNameHasBrackets || other.branchNameHasBrackets,
    );
  }
}
