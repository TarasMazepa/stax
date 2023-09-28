import 'dart:io';

import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/file_path_dir_on_uri.dart';
import 'package:stax/git/git.dart';

class Context {
  final bool silent;
  final String? workingDirectory;

  late final Git git = Git(this);

  Context.implicit() : this(false, null);

  Context(this.silent, this.workingDirectory);

  Context withSilence(bool silent) {
    if (this.silent == silent) return this;
    return Context(silent, workingDirectory);
  }

  Context withWorkingDirectory(String? workingDirectory) {
    if (this.workingDirectory == workingDirectory) return this;
    return Context(silent, workingDirectory);
  }

  Context withScriptPathAsWorkingDirectory() {
    return withWorkingDirectory(Platform.script.toFilePathDir());
  }

  Context withRepositoryRootAsWorkingDirectory() {
    return withWorkingDirectory(getRepositoryRoot());
  }

  void printToConsole(Object? object) {
    if (silent) return;
    print(object);
  }

  bool commandLineContinueQuestion(String questionContext) {
    final includeSpace = questionContext.isNotEmpty &&
        questionContext[questionContext.length - 1] != '\n';
    if (includeSpace) questionContext += " ";
    print("${questionContext}Continue y/N? ");
    return stdin.readLineSync() == 'y';
  }
}
