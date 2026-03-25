extension OnString on String {
  String removeEndingNewLine() {
    if (isEmpty) return this;
    if (this[length - 1] != '\n') return this;
    return substring(0, length - 1);
  }
}
