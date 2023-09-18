import 'arguments_for_internal_command.dart';
import 'internal_command.dart';
import 'internal_commands.dart';

class InternalCommandAvailableCommands extends InternalCommand {
  InternalCommandAvailableCommands()
      : super("help", "list of available commands");

  @override
  void run(final ArgumentsForInternalCommand arguments) {
    print("Here are available commands:");
    for (final element in internalCommands) {
      print(" * ${element.name}");
      print("      ${element.description}");
    }
  }
}
