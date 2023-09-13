import 'command.dart';
import 'dart:io';

class TerminalCommand extends Command {
  const TerminalCommand()
      : super("terminal",
            "command to test how dart executes commands in terminal");

  @override
  void run(List<String> args) {
    switch (args) {
      case []:
        print("No arguments provided");
      case [final executable, ...final arguments]:
        final result = Process.runSync(executable, arguments, runInShell: true);
        print("ExitCode: ${result.exitCode}");
        print("Stdout:   ${result.stdout}".trim());
        print("Stderr:   ${result.stderr}".trim());
    }
  }
}
