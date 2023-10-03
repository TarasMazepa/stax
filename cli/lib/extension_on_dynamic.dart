extension ExtensionOnDynamic<T> on dynamic {
  T map(T Function(dynamic e) call) {
    return call(this);
  }
}
