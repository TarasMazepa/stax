import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

import 'internal_command.dart';
import 'internal_commands.dart';
import 'types_for_internal_command.dart';

class InternalCommandHelp extends InternalCommand {
  InternalCommandHelp()
      : super("help", "List of available commands.",
            flags: {"-a": "Show all commands including hidden."});

  void printMap(
      Context context, String header, Map<String, String>? map, String indent) {
    if (map == null || map.isEmpty) return;
    context.printToConsole("$indent$header:");
    map.forEach((key, value) {
      context.printToConsole("$indent   $key - $value");
    });
  }

  @override
  void run(final List<String> args, final Context context) {
    final showAll = args.contains("-a");
    final commandsToShow = internalCommands.where(
        (element) => showAll || element.type == InternalCommandType.public);
    printMap(context, "Global flags", ContextHandleGlobalFlags.flags, "");
    context.printToConsole("Here are available commands:");
    for (final element in commandsToShow) {
      context.printToConsole(" • ${element.name} - ${element.description}");

      printMap(context, "Positional arguments", element.arguments, "      ");
      printMap(context, "Flags", element.flags, "      ");
    }
  }
}
