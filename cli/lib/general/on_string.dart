extension OnString on String {
  String getFirstLine() {
    final newLineIndex = indexOf('\n');
    if (newLineIndex == -1) return this;
    return substring(0, newLineIndex);
  }

  String enforceMaxLength(int maxLength) {
    if (length > maxLength) return substring(0, maxLength);
    return this;
  }

  String removeEndingNewLine() {
    if (isEmpty) return this;
    if (this[length - 1] != '\n') return this;
    return substring(0, length - 1);
  }
}
