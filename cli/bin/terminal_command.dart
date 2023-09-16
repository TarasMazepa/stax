import 'dart:io';

import 'package:stax/process_result_print.dart';

import 'command.dart';

class TerminalCommand extends Command {
  TerminalCommand()
      : super("terminal",
            "command to test how dart executes commands in terminal");

  @override
  void run(List<String> args) {
    switch (args) {
      case []:
        print("No arguments provided");
      case [final executable, ...final arguments]:
        Process.runSync(executable, arguments).printAll();
    }
  }
}
