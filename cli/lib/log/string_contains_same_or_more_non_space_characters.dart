import 'dart:math';

extension StringContainsSameOrMoreNonSpacePositionalCharacters on String {
  bool containsSameOrMoreNonSpacePositionalCharacters(String other) {
    if (other.length > length) return false;
    final minLength = min(length, other.length);
    for (int i = 0; i < minLength; i++) {
      if (other[i] == " ") continue;
      if (this[i] != " ") continue;
      return false;
    }
    return true;
  }
}
