import 'internal_command.dart';
import 'internal_command_available_commands.dart';
import 'internal_command_commit.dart';
import 'internal_command_delete_gone_branches.dart';
import 'internal_command_main_branch.dart';
import 'internal_command_terminal.dart';
import 'internal_command_update.dart';

final List<InternalCommand> internalCommands = [
  InternalCommandAvailableCommands(),
  InternalCommandTerminal(),
  InternalCommandUpdate(),
  InternalCommandDeleteGoneBranches(),
  InternalCommandCommit(),
  InternalCommandMainBranch(),
]..sort();

final Map<String, InternalCommand> internalCommandRegistry = {
  for (final entry in internalCommands) entry.name: entry
};
