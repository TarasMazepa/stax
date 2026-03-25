import 'dart:convert';
import 'dart:io';

import 'package:stax/context/context.dart';
import 'package:stax/external_command/extended_process_result.dart';
import 'package:stax/external_command/on_process_result.dart';
import 'package:stax/general/on_string.dart';

class ExternalCommand {
  final List<String> _parts;
  final Context context;

  ExternalCommand.explicit(
    String executable,
    List<String> arguments,
    this.context,
  ) : _parts = [executable, ...arguments];

  ExternalCommand(this._parts, this.context);

  ExternalCommand.raw(String command, this.context)
    : _parts = command.split(' ');

  String get executable => _parts[0];

  List<String> get parts => _parts;

  List<String> get arguments => _parts.sublist(1);

  ExternalCommand args(List<String> extra) {
    return ExternalCommand(_parts + extra, context);
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
    if (context.shouldBeQuiet()) return this;
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

  Future<ExtendedProcessResult> run({
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Encoding stdoutEncoding = systemEncoding,
    Encoding stderrEncoding = systemEncoding,
    bool onDemandPrint = false,
  }) async {
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: context.workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
    );
    String Function(List<int>) mapper(Encoding encoding) => onDemandPrint
        ? (codeUnits) {
            context.printToConsole(
              encoding.decode(codeUnits).removeEndingNewLine(),
            );
            return '';
          }
        : encoding.decode;
    final resultParts = await [
      process.exitCode,
      process.stdout.map(mapper(stdoutEncoding)).toList(),
      process.stderr.map(mapper(stderrEncoding)).toList(),
    ].wait;
    String Function(dynamic d) joinStringList = onDemandPrint
        ? (x) => ''
        : (x) => x.join();
    return ProcessResult(
      process.pid,
      resultParts[0] as int,
      joinStringList(resultParts[1]),
      joinStringList(resultParts[2]),
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

  @override
  String toString() {
    return _parts.map((e) => e.contains(' ') ? '"$e"' : e).join(' ');
  }
}
