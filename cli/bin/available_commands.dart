import 'command.dart';
import 'commands.dart';

class AvailableCommands extends Command {
  const AvailableCommands() : super("help", "list of available commands");

  @override
  void run(List<String> args) {
    print("Here are available commands:");
    for (final element in commands) {
      print(" * ${element.name}");
      print("      ${element.description}");
    }
  }
}
