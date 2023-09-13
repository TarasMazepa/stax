import 'available_commands.dart';
import 'command.dart';

const List<Command> commands = [
  AvailableCommands(),
];

final Map<String, Command> commandRegistry = {
  for (final entry in commands) entry.name: entry
};
