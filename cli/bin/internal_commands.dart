import 'internal_command.dart';
import 'internal_command_amend.dart';
import 'internal_command_available_commands.dart';
import 'internal_command_log.dart';
import 'internal_command_commit.dart';
import 'internal_command_delete_gone_branches.dart';
import 'internal_command_main_branch.dart';
import 'internal_command_pull.dart';
import 'internal_command_settings.dart';
import 'internal_command_terminal.dart';
import 'internal_command_update.dart';
import 'internal_command_update_prompt.dart';

final List<InternalCommand> internalCommands = [
  InternalCommandAmend(),
  InternalCommandAvailableCommands(),
  InternalCommandCommit(),
  InternalCommandDeleteGoneBranches(),
  InternalCommandLog(),
  InternalCommandMainBranch(),
  InternalCommandPull(),
  InternalCommandSettings(),
  InternalCommandTerminal(),
  InternalCommandUpdate(),
  InternalCommandUpdatePrompt(),
]..sort();

final Map<String, InternalCommand> internalCommandRegistry = {
  for (final entry in internalCommands) entry.name: entry
};
