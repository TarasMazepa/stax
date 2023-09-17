import 'dart:io';

import 'package:stax/extended_process_result.dart';

import 'command.dart';

class TerminalCommand extends Command {
  TerminalCommand()
      : super(
            "terminal",
            "Command to test how dart executes commands in terminal. "
                "Executes any provided arguments as command in terminal.");

  @override
  void run(List<String> args) {
    switch (args) {
      case []:
        print("No arguments provided.");
      case [final executable, ...final arguments]:
        Process.runSync(executable, arguments)
            .extendWithSilence(false)
            .printAllResultFields();
    }
  }
}
