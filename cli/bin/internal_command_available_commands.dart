import 'package:stax/context_for_internal_command.dart';

import 'internal_command.dart';
import 'internal_commands.dart';
import 'types_for_internal_command.dart';

class InternalCommandAvailableCommands extends InternalCommand {
  InternalCommandAvailableCommands()
      : super("help",
            "List of available commands. Add -a to see hidden commands too.");

  @override
  void run(final ContextForInternalCommand context) {
    context.context.printToConsole("Here are available commands:");
    final showAll = context.args.contains("-a");
    final commandsToShow = internalCommands.where(
        (element) => showAll || element.type == InternalCommandType.public);
    for (final element in commandsToShow) {
      context.context.printToConsole(" * ${element.name}");
      context.context.printToConsole("      ${element.description}");
    }
  }
}
