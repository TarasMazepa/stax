import 'dart:io';

import 'package:stax/git/git.dart';

class Context {
  final bool silent;
  final String? workingDirectory;

  late final Git git = Git(this);

  Context.empty() : this(false, null);

  Context(this.silent, this.workingDirectory);

  Context withSilence(bool silent) {
    if (this.silent == silent) return this;
    return Context(silent, workingDirectory);
  }

  Context withWorkingDirectory(String? workingDirectory) {
    if (this.workingDirectory == workingDirectory) return this;
    return Context(silent, workingDirectory);
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
