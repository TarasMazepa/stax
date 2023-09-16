class FieldInfo<V, S> {
  final String prefix;
  final V Function(S source) getter;
  final bool Function(V value) checker;

  FieldInfo(this.prefix, this.getter, this.checker);

  V getValue(S source) {
    return getter(source);
  }

  void printValue(V value) {
    print("$prefix$value");
  }

  void printFieldOf(S source) {
    printValue(getValue(source));
  }

  void printFieldOfIfChecked(S source) {
    final value = getValue(source);
    if (checker(value)) printValue(value);
  }

  bool check(S source) {
    final value = getValue(source);
    return checker(value);
  }
}
