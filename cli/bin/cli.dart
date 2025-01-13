import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/main_function_reference.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

void main(List<String> arguments) {
  mainFunctionReference = main;
  arguments = arguments.toList();
  final context = Context.implicit().handleGlobalFlags(arguments);
  switch (arguments) {
    case []:
      InternalCommandHelp().run([], context);
    case [final commandName, ...final args]:
      final command = internalCommands
              .where(
                (command) =>
                    command.name == commandName ||
                    command.shortName == commandName,
              )
              .firstOrNull ??
          internalCommands
              .where((command) => command.name.startsWith(commandName))
              .firstOrNull;
      if (command == null) {
        context.printParagraph("Unknown command '$commandName'.");
        return;
      }
      command.run(args, context);
  }
}
