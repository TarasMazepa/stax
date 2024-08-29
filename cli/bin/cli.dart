import 'package:stax/command/internal_command.dart';
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
      final command = internalCommandRegistry.entries.fold<InternalCommand?>(
        null,
        (previous, element) => element.key.startsWith(commandName)
            ? element.key.length <=
                    (previous?.name.length ?? element.key.length)
                ? element.value
                : previous
            : previous,
      );
      if (command == null) {
        context.printToConsole("Unknown command '$commandName'.");
      } else {
        command.run(args, context);
      }
  }
  if (arguments.contains("--old-style-installation")) {
    context.printParagraph("""You are using old style installation. Check

https://github.com/TarasMazepa/stax?tab=readme-ov-file#installation

for most up to date installation instructions for your OS.""");
  }
}
