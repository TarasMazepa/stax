class Once {
  bool executed = false;

  void attempt(void Function() call) {
    if (executed) return;
    executed = true;
    call();
  }

  void Function() wrap(void Function() call) {
    return () => attempt(call);
  }
}
