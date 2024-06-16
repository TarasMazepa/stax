import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

import 'internal_command_help.dart';
import 'internal_commands.dart';

void main(List<String> arguments) {
  arguments = arguments.toList();
  final context = Context.implicit().handleGlobalFlags(arguments);
  switch (arguments) {
    case []:
      InternalCommandHelp().run([], context);
    case [final commandName, ...final args]:
      final command = internalCommandRegistry[commandName];
      if (command == null) {
        context.printToConsole("Unknown command '$commandName'.");
      } else {
        command.run(args, context);
      }
  }
  if (arguments.contains("--old-style-installation")) {
    context.printParagraph(
        "You are using old style installation. Check https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation for most up to date installation instructions for your OS.");
  }
}
