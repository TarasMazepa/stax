import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/main_function_reference.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

void main(List<String> arguments) {
  // report(arguments);
  mainFunctionReference = main;
  arguments = arguments.toList();
  final context = Context.implicit().handleGlobalFlags(arguments);
  switch (arguments) {
    case []:
      InternalCommandHelp().run([], context);
    case [final commandName, ...final args]:
      final command =
          internalCommands
              .where(
                (command) =>
                    command.name == commandName ||
                    command.shortName == commandName,
              )
              .firstOrNull ??
          internalCommands.fold<InternalCommand?>(
            null,
            (current, command) => switch (command) {
              _ when !command.name.startsWith(commandName) => current,
              _ when current == null => command,
              _ when current.type.isHidden && command.type.isPublic => command,
              _ when current.name.length > command.name.length => command,
              _ when current.name.length < command.name.length => current,
              _ => current,
            },
          );
      if (command == null) {
        context.printParagraph(
          "Unknown command or prefix of a command '$commandName'.",
        );
        return;
      }
      if (context.hasHelpFlag(args)) {
        InternalCommandHelp().run([command.name], context);
      } else {
        command.run(args, context);
      }
  }
}
