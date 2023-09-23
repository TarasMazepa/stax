import 'package:stax/git/git.dart';

class Context {
  final bool silent;

  late final Git git = Git(this);

  Context({this.silent = false});

  Context.silent() : this(silent: true);

  Context.loud() : this(silent: false);

  void printToConsole(Object? object) {
    if (silent) return;
    print(object);
  }
}
