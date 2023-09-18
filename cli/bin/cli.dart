import 'context_for_internal_command.dart';
import 'internal_command_available_commands.dart';
import 'internal_commands.dart';

void main(List<String> arguments) {
  switch (arguments) {
    case []:
      InternalCommandAvailableCommands().run(ContextForInternalCommand.empty());
    case [final commandName, ...final args]:
      final command = internalCommandRegistry[commandName];
      if (command == null) {
        print("unknown command '$commandName'");
        return;
      }
      command.run(ContextForInternalCommand(args));
  }
}
