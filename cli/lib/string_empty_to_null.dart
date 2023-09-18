extension EmptyToNull on String {
  String? emptyToNull() {
    if (isEmpty) return null;
    return this;
  }
}
