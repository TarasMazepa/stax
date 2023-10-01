import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

import 'internal_command_available_commands.dart';
import 'internal_command_update.dart';
import 'internal_command_update_prompt.dart';
import 'internal_commands.dart';

void main(List<String> arguments) {
  arguments = arguments.toList();
  final context = Context.implicit().handleGlobalFlags(arguments);
  bool shouldUpdate = InternalCommandUpdatePrompt()
      .shouldAutoUpdateAfterExecutingCommand([], context.withSilence(true));
  switch (arguments) {
    case []:
      InternalCommandAvailableCommands().run([], context);
    case [final commandName, ...final args]:
      final command = internalCommandRegistry[commandName];
      if (command == null) {
        print("Unknown command '$commandName'.");
        return;
      }
      command.run(args, context);
  }
  if (shouldUpdate) {
    InternalCommandUpdate().run([], context);
  }
}
