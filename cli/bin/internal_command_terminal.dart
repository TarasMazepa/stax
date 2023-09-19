import 'dart:io';

import 'package:stax/external_command.dart';

import 'context_for_internal_command.dart';
import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandTerminal extends InternalCommand {
  InternalCommandTerminal()
      : super(
            "terminal",
            "Command to test how dart executes commands in terminal. "
                "Executes any provided arguments as command in terminal.",
            type: InternalCommandType.hidden);

  @override
  void run(final ContextForInternalCommand context) {
    context.printToConsole(Platform.script.toFilePath());
    switch (context.args) {
      case []:
        context.printToConsole("No arguments provided.");
      default:
        ExternalCommand(context.args).runSync().printAllResultFields();
    }
  }
}
