import 'dart:io';

import 'package:stax/git/git.dart';

class Context {
  final bool silent;

  late final Git git = Git(this);

  Context({this.silent = false});

  Context.silent() : this(silent: true);

  Context.loud() : this(silent: false);

  Context withSilence(bool targetSilent) {
    if (silent == targetSilent) return this;
    return Context(silent: targetSilent);
  }

  void printToConsole(Object? object) {
    if (silent) return;
    print(object);
  }

  bool commandLineContinueQuestion(String questionContext) {
    print("$questionContext Continue y/N? ");
    return stdin.readLineSync() == 'y';
  }
}
