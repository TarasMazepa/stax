extension OnObject<T> on T? {
  bool isIn(Set<T> set) {
    return set.contains(this);
  }
}
