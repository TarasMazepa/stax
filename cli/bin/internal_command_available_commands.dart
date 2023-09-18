import 'context_for_internal_command.dart';
import 'internal_command.dart';
import 'internal_commands.dart';

class InternalCommandAvailableCommands extends InternalCommand {
  InternalCommandAvailableCommands()
      : super("help", "list of available commands");

  @override
  void run(final ContextForInternalCommand context) {
    context.printToConsole("Here are available commands:");
    for (final element in internalCommands) {
      context.printToConsole(" * ${element.name}");
      context.printToConsole("      ${element.description}");
    }
  }
}
