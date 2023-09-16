import 'dart:convert';
import 'dart:io';

class ExternalCommand {
  final List<String> parts;

  ExternalCommand(this.parts);

  ExternalCommand.split(String command) : parts = command.split(" ");

  String get executable => parts[0];

  List<String> get arguments => parts.sublist(1);

  ExternalCommand withExtraArguments(List<String> extra) {
    return ExternalCommand(parts.followedBy(extra).toList());
  }

  ExternalCommand announce() {
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

  @override
  String toString() {
    return parts.join(" ");
  }
}
