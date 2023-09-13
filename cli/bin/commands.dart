import 'available_commands.dart';
import 'command.dart';
import 'terminal_command.dart';

const List<Command> commands = [
  AvailableCommands(),
  TerminalCommand(),
];

final Map<String, Command> commandRegistry = {
  for (final entry in commands) entry.name: entry
};
