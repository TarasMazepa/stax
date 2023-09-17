extension CountOnList<T> on List<T> {
  int count(T item) {
    int result = 0;
    for (var value in this) {
      if (value == item) result++;
    }
    return result;
  }
}
