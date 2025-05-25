import 'dart:convert';
import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/external_command/extended_process_result.dart';

class ExternalCommand {
  final List<String> parts;
  final Context context;

  ExternalCommand(this.parts, this.context);

  ExternalCommand.raw(String command, this.context)
    : parts = command.split(' ');

  String get executable => parts[0];

  List<String> get arguments => parts.sublist(1);

  ExternalCommand args(List<String> extra) {
    return ExternalCommand(parts + extra, context);
  }

  ExternalCommand arg(String extra) {
    return args([extra]);
  }

  ExternalCommand? askContinueQuestion(
    String questionContext, {
    bool assumeYes = false,
    bool assumeNo = false,
  }) {
    if (assumeYes) return this;
    if (assumeNo) return null;
    return context.commandLineContinueQuestion(questionContext) ? this : null;
  }

  ExternalCommand announce([String? announcement]) {
    context.printToConsole('');
    if (announcement != null) context.printToConsole('# $announcement');
    String path = context.workingDirectory != null
        ? '[${context.workingDirectory}] '
        : '';
    context.printToConsole('$path> ${toString()}');
    return this;
  }

  ExtendedProcessResult runSync({
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) {
    return Process.runSync(
      executable,
      arguments,
      workingDirectory: context.workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
    ).extend(this);
  }

  ExtendedProcessResult? runSyncCatching({
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) {
    try {
      return runSync(
        environment: environment,
        includeParentEnvironment: includeParentEnvironment,
        runInShell: runInShell,
        stdoutEncoding: stdoutEncoding,
        stderrEncoding: stderrEncoding,
      );
    } catch (e) {
      return null;
    }
  }

  Future<ExtendedProcessResult> run({
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding? stdoutEncoding = systemEncoding,
    Encoding? stderrEncoding = systemEncoding,
  }) {
    return Process.run(
      executable,
      arguments,
      workingDirectory: context.workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      stdoutEncoding: stdoutEncoding,
      stderrEncoding: stderrEncoding,
    ).then((value) => value.extend(this));
  }

  @override
  String toString() {
    return parts.map((e) => e.contains(' ') ? '"$e"' : e).join(' ');
  }
}
