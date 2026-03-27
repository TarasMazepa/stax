extension CompareChainExtension<T extends Comparable<dynamic>> on T {
  int? compareChain(T other) {
    final result = compareTo(other);
    return result == 0 ? null : result;
  }
}

extension BoolCompareChainExtension on bool {
  int? compareChain(bool other) {
    if (this == other) return null;
    return this ? 1 : -1;
  }

  int? compareChainReverse(bool other) {
    if (this == other) return null;
    return this ? -1 : 1;
  }
}
