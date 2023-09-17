import 'dart:convert';
import 'dart:io';

bool commandLineContinueQuestion(String context) {
  stdout.write("$context Continue y/N? ");
  return stdin.readLineSync() == 'y';
}

class ExternalCommand {
  final List<String> parts;

  ExternalCommand(this.parts);

  ExternalCommand.split(String command) : parts = command.split(" ");

  String get executable => parts[0];

  List<String> get arguments => parts.sublist(1);

  ExternalCommand withArguments(List<String> extra) {
    return ExternalCommand(parts.followedBy(extra).toList());
  }

  ExternalCommand withArgument(String extra) {
    return withArguments([extra]);
  }

  ExternalCommand? askContinueQuestion(String context) {
    return commandLineContinueQuestion(context) ? this : null;
  }

  ExternalCommand announce([String? context]) {
    if (context != null) print("# $context");
    print("> ${toString()}");
    return this;
  }

  ProcessResult runSync(
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
        stderrEncoding: stderrEncoding);
  }

  Future<ProcessResult> run(
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
        stderrEncoding: stderrEncoding);
  }

  @override
  String toString() {
    return parts.join(" ");
  }
}
