import 'package:collection/collection.dart';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

class InternalCommandHelp extends InternalCommand {
  static final showAllFlag = Flag(
    short: '-a',
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
  void run(final List<String> args, final Context context) {
    final showAll = showAllFlag.hasFlag(args);
    final selectedCommand = args.elementAtOrNull(0);
    final singleCommand = selectedCommand != null;
    final commandsToShow = internalCommands.where(
      (element) => switch (element) {
        _ when singleCommand => element.name == selectedCommand,
        _ when showAll => true,
        _ => element.type == InternalCommandType.public,
      }
    );
    printFlags(context, 'Global flags', ContextHandleGlobalFlags.flags, '');
    if (!singleCommand) {
      context.printToConsole('Here are available commands:');
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
