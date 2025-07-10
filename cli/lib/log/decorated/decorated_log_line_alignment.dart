import 'dart:math';

class DecoratedLogLineAlignment {
  final int branchNameLength;
  final int decorationLength;

  DecoratedLogLineAlignment(this.branchNameLength, this.decorationLength);

  DecoratedLogLineAlignment.zero() : this(0, 0);

  DecoratedLogLineAlignment operator +(DecoratedLogLineAlignment other) {
    return DecoratedLogLineAlignment(
      max(branchNameLength, other.branchNameLength),
      max(decorationLength, other.decorationLength),
    );
  }
}
