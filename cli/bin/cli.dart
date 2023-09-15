import 'available_commands.dart';
import 'commands.dart';

void main(List<String> arguments) {
  switch (arguments) {
    case []:
      print("No command provided");
      AvailableCommands().run([]);
    case [final commandName, ...final args]:
      final command = commandRegistry[commandName];
      if (command == null) {
        print("unknown command '$commandName'");
        return;
      }
      command.run(args);
  }
}
