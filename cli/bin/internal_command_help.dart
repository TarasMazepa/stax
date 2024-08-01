import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

import 'internal_command.dart';
import 'internal_commands.dart';
import 'types_for_internal_command.dart';

class InternalCommandHelp extends InternalCommand {
  InternalCommandHelp()
      : super("help", "List of available commands.",
            flags: {"-a": "Show all commands including hidden."});

  void printEntries(Context context, String header,
      List<MapEntry<String, String>>? entries, String indent) {
    if (entries == null || entries.isEmpty) return;
    context.printToConsole("$indent$header:");
    for (var entry in entries) {
      context.printToConsole("$indent   ${entry.key} - ${entry.value}");
    }
  }

  void printMapSorted(
      Context context, String header, Map<String, String>? map, String indent) {
    printEntries(
      context,
      header,
      map?.entries.sortedBy(
        (x) => x.key.replaceAll("-", ""),
      ),
      indent,
    );
  }

  void printMap(
      Context context, String header, Map<String, String>? map, String indent) {
    printEntries(
      context,
      header,
      map?.entries.toList(),
      indent,
    );
  }

  @override
  void run(final List<String> args, final Context context) {
    final showAll = args.contains("-a");
    final commandsToShow = internalCommands.where(
        (element) => showAll || element.type == InternalCommandType.public);
    printMapSorted(context, "Global flags", ContextHandleGlobalFlags.flags, "");
    context.printToConsole("Here are available commands:");
    for (final element in commandsToShow) {
      context.printToConsole(" • ${element.name} - ${element.description}");

      printMap(context, "Positional arguments", element.arguments, "      ");
      printMapSorted(context, "Flags", element.flags, "      ");
    }
  }
}
