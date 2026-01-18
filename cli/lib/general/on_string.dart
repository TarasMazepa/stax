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
}
