import 'dart:io';

import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:stax/external_command/external_command.dart';
import 'package:stax/file_path_dir_on_uri.dart';
import 'package:stax/git/git.dart';

class Context {
  final bool silent;
  final bool forcedLoudness;
  final bool acceptAll;
  final bool declineAll;
  final String? workingDirectory;

  late final Git git = Git(this);

  Context.implicit() : this(false, null, false, false, false);

  Context(this.silent, this.workingDirectory, this.forcedLoudness,
      this.acceptAll, this.declineAll);

  ExternalCommand command([List<String>? parts]) {
    return ExternalCommand(parts ?? [], this);
  }

  Context withSilence(bool silent) {
    if (this.silent == silent) return this;
    return Context(
        silent, workingDirectory, forcedLoudness, acceptAll, declineAll);
  }

  Context withForcedLoudness(bool forcedLoudness) {
    if (this.forcedLoudness == forcedLoudness) return this;
    return Context(
        silent, workingDirectory, forcedLoudness, acceptAll, declineAll);
  }

  Context withWorkingDirectory(String? workingDirectory) {
    if (this.workingDirectory == workingDirectory) return this;
    return Context(
        silent, workingDirectory, forcedLoudness, acceptAll, declineAll);
  }

  Context withScriptPathAsWorkingDirectory() {
    return withWorkingDirectory(Platform.script.toFilePathDir());
  }

  Context withRepositoryRootAsWorkingDirectory() {
    return withWorkingDirectory(getRepositoryRoot());
  }

  Context withAcceptingAll(bool acceptAll) {
    if (this.acceptAll == acceptAll) return this;
    return Context(
        silent, workingDirectory, forcedLoudness, acceptAll, declineAll);
  }

  Context withDecliningAll(bool declineAll) {
    if (this.declineAll == declineAll) return this;
    return Context(
        silent, workingDirectory, forcedLoudness, acceptAll, declineAll);
  }

  void printToConsole(Object? object) {
    if (!forcedLoudness && silent) return;
    print(object);
  }

  bool commandLineContinueQuestion(String questionContext) {
    if (declineAll) {
      printToConsole(
          "Automatically declining '$questionContext' as per user request.");
      return false;
    }
    if (acceptAll) {
      printToConsole(
          "Automatically accepting '$questionContext' as per user request.");
      return true;
    }
    final includeSpace = questionContext.isNotEmpty &&
        questionContext[questionContext.length - 1] != '\n';
    if (includeSpace) questionContext += " ";
    print("${questionContext}Continue y/N? ");
    return stdin.readLineSync() == 'y';
  }
}
