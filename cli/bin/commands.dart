import 'available_commands.dart';
import 'command.dart';
import 'delete_gone_branches_command.dart';
import 'terminal_command.dart';
import 'update_command.dart';

const List<Command> commands = [
  AvailableCommands(),
  TerminalCommand(),
  UpdateCommand(),
  DeleteGoneBranchesCommand(),
];

final Map<String, Command> commandRegistry = {
  for (final entry in commands) entry.name: entry
};
