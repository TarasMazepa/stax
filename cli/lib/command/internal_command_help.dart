import 'package:collection/collection.dart';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

class InternalCommandHelp extends InternalCommand {
  static final showAllFlag =
      Flag(short: '-a', description: 'Show all commands including hidden.');

  InternalCommandHelp()
      : super(
          'help',
          'List of available commands.',
          flags: [
            showAllFlag,
          ],
        );

  void printIndented(
    Context context,
    String header,
    Iterable<MapEntry<String, String>>? entries,
    String indent,
  ) {
    if (entries == null || entries.isEmpty) return;
    context.printToConsole('$indent$header:');
    for (var entry in entries) {
      context.printToConsole('$indent   ${entry.key} - ${entry.value}');
    }
  }

  void printIndentedSorted(
    Context context,
    String header,
    Iterable<MapEntry<String, String>>? entries,
    String indent,
  ) {
    printIndented(
      context,
      header,
      entries?.sortedBy(
        (x) => x.key.replaceAll('-', ''),
      ),
      indent,
    );
  }

  @override
  void run(final List<String> args, final Context context) {
    final showAll = showAllFlag.hasFlag(args);
    final commandsToShow = internalCommands.where(
      (element) => showAll || element.type == InternalCommandType.public,
    );
    printIndentedSorted(
      context,
      'Global flags',
      ContextHandleGlobalFlags.flags.entries,
      '',
    );
    context.printToConsole('Here are available commands:');
    context.printToConsole(
      "Note: you can type first letter or couple of first letters instead of full command name. 'c' for 'commit' or 'am' for 'amend'.",
    );
    for (final element in commandsToShow) {
      context.printToConsole(' • ${element.name} - ${element.description}');

      printIndented(
        context,
        'Positional arguments',
        element.arguments?.entries.toList(),
        '      ',
      );
      printIndentedSorted(
        context,
        'Flags',
        element.flags?.map(
          (e) => MapEntry([e.short, e.long].nonNulls.join(', '), e.description),
        ),
        '      ',
      );
    }
  }
}
