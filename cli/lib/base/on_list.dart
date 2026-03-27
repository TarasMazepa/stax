extension OnList<T> on List<T> {
  T? elementAtOrNull(int index) {
    if (index >= length) return null;
    return this[index];
  }
}
