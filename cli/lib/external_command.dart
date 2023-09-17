import 'dart:convert';
import 'dart:io';

import 'package:stax/extended_process_result.dart';

bool commandLineContinueQuestion(String context) {
  stdout.write("$context Continue y/N? ");
  return stdin.readLineSync() == 'y';
}

class ExternalCommand {
  final List<String> parts;
  final bool silent;

  ExternalCommand(this.parts, this.silent);

  ExternalCommand.split(String command)
      : parts = command.split(" "),
        silent = false;

  String get executable => parts[0];

  List<String> get arguments => parts.sublist(1);

  ExternalCommand silence(bool targetSilence) {
    if (targetSilence == silent) return this;
    return ExternalCommand(parts, targetSilence);
  }

  ExternalCommand withArguments(List<String> extra) {
    return ExternalCommand(parts.followedBy(extra).toList(), silent);
  }

  ExternalCommand withArgument(String extra) {
    return withArguments([extra]);
  }

  ExternalCommand? askContinueQuestion(String context) {
    return commandLineContinueQuestion(context) ? this : null;
  }

  ExternalCommand announce([String? context]) {
    if (silent) return this;
    if (context != null) print("# $context");
    print("> ${toString()}");
    return this;
  }

  ExtendedProcessResult runSync(
      {String? workingDirectory,
      Map<String, String>? environment,
      bool includeParentEnvironment = true,
      bool runInShell = false,
      Encoding? stdoutEncoding = systemEncoding,
      Encoding? stderrEncoding = systemEncoding}) {
    return Process.runSync(executable, arguments,
            workingDirectory: workingDirectory,
            environment: environment,
            includeParentEnvironment: includeParentEnvironment,
            runInShell: runInShell,
            stdoutEncoding: stdoutEncoding,
            stderrEncoding: stderrEncoding)
        .extend(this);
  }

  Future<ExtendedProcessResult> run(
      {String? workingDirectory,
      Map<String, String>? environment,
      bool includeParentEnvironment = true,
      bool runInShell = false,
      Encoding? stdoutEncoding = systemEncoding,
      Encoding? stderrEncoding = systemEncoding}) {
    return Process.run(executable, arguments,
            workingDirectory: workingDirectory,
            environment: environment,
            includeParentEnvironment: includeParentEnvironment,
            runInShell: runInShell,
            stdoutEncoding: stdoutEncoding,
            stderrEncoding: stderrEncoding)
        .then((value) => value.extend(this));
  }

  @override
  String toString() {
    return parts.join(" ");
  }
}
