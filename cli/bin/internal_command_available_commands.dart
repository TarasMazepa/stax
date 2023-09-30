import 'package:stax/context/context.dart';

import 'internal_command.dart';
import 'internal_commands.dart';
import 'types_for_internal_command.dart';

class InternalCommandAvailableCommands extends InternalCommand {
  InternalCommandAvailableCommands()
      : super("help",
            "List of available commands. Add -a to see hidden commands too.");

  @override
  void run(final List<String> args, final Context context) {
    context.printToConsole("Here are available commands:");
    final showAll = args.contains("-a");
    final commandsToShow = internalCommands.where(
        (element) => showAll || element.type == InternalCommandType.public);
    for (final element in commandsToShow) {
      context.printToConsole(" • ${element.name} - ${element.description}");
      printMap(String header, Map<String, String>? map) {
        if (map == null || map.isEmpty) return;
        context.printToConsole("      $header:");
        map.forEach((key, value) {
          context.printToConsole("         $key - $value");
        });
      }

      printMap("Positional arguments", element.arguments);
      printMap("Flags", element.flags);
    }
  }
}
