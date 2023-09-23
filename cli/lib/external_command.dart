import 'dart:convert';
import 'dart:io';

import 'package:stax/context.dart';
import 'package:stax/extended_process_result.dart';

bool commandLineContinueQuestion(String context) {
  stdout.write("$context Continue y/N? ");
  return stdin.readLineSync() == 'y';
}

class ExternalCommand {
  final List<String> parts;
  final Context context;

  ExternalCommand(this.parts, {bool silent = false})
      : context = Context(silent: silent);

  ExternalCommand.raw(String command, {bool silent = false})
      : parts = command.split(" "),
        context = Context(silent: silent);

  String get executable => parts[0];

  List<String> get arguments => parts.sublist(1);

  ExternalCommand silence(bool targetSilence) {
    if (targetSilence == context.silent) return this;
    return ExternalCommand(parts, silent: targetSilence);
  }

  ExternalCommand args(List<String> extra) {
    return ExternalCommand(parts + extra, silent: context.silent);
  }

  ExternalCommand arg(String extra) {
    return args([extra]);
  }

  ExternalCommand? askContinueQuestion(String context) {
    return commandLineContinueQuestion(context) ? this : null;
  }

  ExternalCommand announce([String? announcement]) {
    if (context.silent) return this;
    print("");
    if (announcement != null) print("# $announcement");
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
    return parts.map((e) => e.contains(" ") ? "\"$e\"" : e).join(" ");
  }
}
