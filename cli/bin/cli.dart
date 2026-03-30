import 'package:stax/command/internal_command_extras.dart';
import 'package:stax/command/internal_command_finder.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_command_log.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/main_function_reference.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

Future<void> main(List<String> arguments) async {
  mainFunctionReference = main;
  arguments = arguments.toList();
  final context = Context.implicit().handleGlobalFlags(arguments);
  final shouldLogAfterwards = context.hasLogFlag(arguments);
  switch (arguments) {
    case []:
      await InternalCommandHelp().run([], context);
    case [final commandName, ...final args]:
      final command =
          internalCommands.findByNameOrPrefix(commandName) ??
          extraCommands.findByNameOrPrefix(commandName);
      if (command == null) {
        context.printParagraph(
          "Unknown command or prefix of a command '$commandName'.",
        );
        return;
      }
      if (context.hasHelpFlag(args)) {
        await InternalCommandHelp().run([command.name, ...args], context);
      } else {
        await command.run(args, context);
      }
  }
  if (shouldLogAfterwards) {
    await InternalCommandLog().run([], context);
  }
}
