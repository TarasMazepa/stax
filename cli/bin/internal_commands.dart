import 'internal_command.dart';
import 'internal_command_amend.dart';
import 'internal_command_checkout.dart';
import 'internal_command_commit.dart';
import 'internal_command_delete_gone_branches.dart';
import 'internal_command_doctor.dart';
import 'internal_command_help.dart';
import 'internal_command_log.dart';
import 'internal_command_log_test_case.dart';
import 'internal_command_main_branch.dart';
import 'internal_command_move.dart';
import 'internal_command_pull.dart';
import 'internal_command_rebase.dart';
import 'internal_command_settings.dart';
import 'internal_command_terminal.dart';
import 'internal_command_update.dart';
import 'internal_command_update_prompt.dart';
import 'internal_command_version.dart';

final List<InternalCommand> internalCommands = [
  InternalCommandAmend(),
  InternalCommandCommit(),
  InternalCommandCheckout(),
  InternalCommandDeleteGoneBranches(),
  InternalCommandDoctor(),
  InternalCommandHelp(),
  InternalCommandLog(),
  InternalCommandLogTestCase(),
  InternalCommandMainBranch(),
  InternalCommandMove(),
  InternalCommandPull(),
  InternalCommandRebase(),
  InternalCommandSettings(),
  InternalCommandTerminal(),
  InternalCommandUpdate(),
  InternalCommandUpdatePrompt(),
  InternalCommandVersion(),
]..sort();

final Map<String, InternalCommand> internalCommandRegistry = {
  for (final entry in internalCommands) entry.name: entry
};
