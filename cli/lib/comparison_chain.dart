class ComparisonChain {
  int _result = 0;

  ComparisonChain chain(int Function() compare) {
    if (_result == 0) _result = compare();
    return this;
  }

  ComparisonChain chainBool(bool left, bool right) {
    int boolToInt(bool x) => x ? 1 : -1;
    return chain(() => boolToInt(left) - boolToInt(right));
  }

  ComparisonChain chainBoolReverse(bool left, bool right) {
    return chainBool(!left, !right);
  }

  int compare() {
    return _result;
  }
}
