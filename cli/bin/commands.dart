import 'available_commands.dart';
import 'command.dart';
import 'commit_command.dart';
import 'delete_gone_branches_command.dart';
import 'terminal_command.dart';
import 'update_command.dart';

final List<Command> commands = [
  AvailableCommands(),
  TerminalCommand(),
  UpdateCommand(),
  DeleteGoneBranchesCommand(),
  CommitCommand(),
];

final Map<String, Command> commandRegistry = {
  for (final entry in commands) entry.name: entry
};
