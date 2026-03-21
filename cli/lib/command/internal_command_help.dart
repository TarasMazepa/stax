import 'package:collection/collection.dart';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_extras.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/command/types_for_internal_command.dart';
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
        type: InternalCommandType.hidden,
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
    final positionalArgs = args.where((arg) => !arg.startsWith('-')).toList();
    final singleCommand = positionalArgs.isNotEmpty;

    Iterable<InternalCommand> commandsToShow;
    bool isExtrasList = false;

    if (singleCommand) {
      final firstCommand = positionalArgs[0];
      if (firstCommand == 'extras' || firstCommand == 'e') {
        final extrasCmd = internalCommands
            .whereType<InternalCommandExtras>()
            .first;
        if (positionalArgs.length > 1) {
          final subCommandName = positionalArgs[1];
          final subCommand = extrasCmd.extraCommands.firstWhereOrNull(
            (c) => c.name == subCommandName || c.shortName == subCommandName,
          );
          if (subCommand != null) {
            commandsToShow = [subCommand];
          } else {
            commandsToShow = [];
          }
        } else {
          commandsToShow = extrasCmd.extraCommands;
          isExtrasList = true;
        }
      } else {
        final command = internalCommands.firstWhereOrNull(
          (c) => c.name == firstCommand || c.shortName == firstCommand,
        );
        if (command != null) {
          commandsToShow = [command];
        } else {
          // Fallback, we might just not find it, or it was passed as prefix which is not handled here exactly like this,
          // but we can just use the name check from before.
          commandsToShow = internalCommands.where(
            (element) => element.name == firstCommand,
          );
          if (commandsToShow.isEmpty) {
            // Maybe it's a subcommand of extras directly requested like `changelog` without `extras` keyword?
            final extrasCmd = internalCommands
                .whereType<InternalCommandExtras>()
                .first;
            final subCommand = extrasCmd.extraCommands.firstWhereOrNull(
              (c) => c.name == firstCommand || c.shortName == firstCommand,
            );
            if (subCommand != null) {
              commandsToShow = [subCommand];
            }
          }
        }
      }
    } else {
      commandsToShow = internalCommands.where(
        (element) => showAll || element.type == InternalCommandType.public,
      );
    }

    printFlags(context, 'Global flags', ContextHandleGlobalFlags.flags, '');

    if (!singleCommand || isExtrasList) {
      if (isExtrasList) {
        context.printToConsole('Here are available commands under `extras`:');
      } else {
        context.printToConsole('Here are available commands:');
      }
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
