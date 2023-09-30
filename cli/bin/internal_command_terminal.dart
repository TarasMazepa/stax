import 'package:stax/context/context.dart';
import 'package:stax/external_command/external_command.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandTerminal extends InternalCommand {
  InternalCommandTerminal()
      : super(
            "terminal",
            "Command to test how dart executes commands in terminal. "
                "Executes any provided arguments as command in terminal.",
            type: InternalCommandType.hidden,
            arguments: {
              "arg1, [arg2, ...]":
                  "Any number of positional arguments that would be executed in terminal for you. At least one required.",
            });

  @override
  void run(final List<String> args, final Context context) {
    switch (args) {
      case []:
        context.printToConsole("No arguments provided.");
      default:
        ExternalCommand(args, context)
            .announce("Running your command.")
            .runSync()
            .printNotEmptyResultFields();
    }
  }
}
