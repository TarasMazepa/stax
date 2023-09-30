class Once {
  bool executed = false;

  void attempt(void Function() call) {
    if (executed) return;
    executed = true;
    call();
  }
}
