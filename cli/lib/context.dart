class Context {
  final bool silent;

  Context({this.silent = false});

  Context.silent() : this(silent: true);

  Context.loud() : this(silent: false);
}

extension ToContextOnBool on bool {
  Context toContext() {
    return Context(silent: this);
  }
}
