import 'package:collection/collection.dart';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_extras.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/command/internal_command_finder.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

class InternalCommandHelp extends InternalCommand {
  static final showAllFlag = Flag(
    short: '-a',
    long: '--show-all',
    description: 'Show all commands including hidden.',
  );

  InternalCommandHelp()
    : super(
        'help',
        'List of available commands.',
        flags: [showAllFlag],
        arguments: {
          'opt1': 'Optional name of the command you want to learn about',
        },
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

  void printFlags(
    Context context,
    String header,
    List<Flag>? flags,
    String indent,
  ) {
    printIndented(
      context,
      header,
      flags
          ?.map(
            (e) =>
                MapEntry([e.short, e.long].nonNulls.join(', '), e.description),
          )
          .sortedBy((x) => x.key.replaceAll('-', '')),
      indent,
    );
  }

  @override
  Future<void> run(final List<String> args, final Context context) async {
    final showAll = showAllFlag.hasFlag(args);

    Iterable<InternalCommand> commandsToShow;
    String? headerMessage;

    switch (args) {
      case ['extras', final subCommandName, ...]:
        final extrasCmd = internalCommands
            .whereType<InternalCommandExtras>()
            .first;
        final command = extrasCmd.extraCommands.findByNameOrPrefix(
          subCommandName,
        );
        commandsToShow = command != null ? [command] : [];
      case ['extras']:
        final extrasCmd = internalCommands
            .whereType<InternalCommandExtras>()
            .first;
        commandsToShow = extrasCmd.extraCommands;
        headerMessage = 'Here are available commands under `extras`:';
      case [final selectedCommand, ...]:
        final command = internalCommands.findByNameOrPrefix(selectedCommand);
        commandsToShow = command != null ? [command] : [];
      case []:
      default:
        commandsToShow = internalCommands
            .where(
              (element) =>
                  showAll || element.type == InternalCommandType.public,
            )
            .sorted((a, b) {
              if (a is InternalCommandExtras && b is! InternalCommandExtras)
                return 1;
              if (a is! InternalCommandExtras && b is InternalCommandExtras)
                return -1;
              return a.compareTo(b);
            });
        headerMessage = 'Here are available commands:';
    }

    printFlags(context, 'Global flags', ContextHandleGlobalFlags.flags, '');

    if (headerMessage != null) {
      context.printToConsole(headerMessage);
      context.printToConsole(
        "Note: you can type first letter or couple of first letters instead of full command name. 'c' for 'commit' or 'am' for 'amend'.",
      );
    }

    for (final element in commandsToShow) {
      context.printToConsole(
        ' • ${element.name}${element.shortName != null ? ", ${element.shortName}" : ""} - ${element.description}',
      );

      printIndented(
        context,
        'Positional arguments',
        element.arguments?.entries.toList(),
        '      ',
      );
      printFlags(context, 'Flags', element.flags, '      ');
    }
  }
}
