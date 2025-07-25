import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_about.dart';
import 'package:stax/command/internal_command_amend.dart';
import 'package:stax/command/internal_command_commit.dart';
import 'package:stax/command/internal_command_delete_stale.dart';
import 'package:stax/command/internal_command_doctor.dart';
import 'package:stax/command/internal_command_get.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_command_log.dart';
import 'package:stax/command/internal_command_log_test_case.dart';
import 'package:stax/command/internal_command_main_branch.dart';
import 'package:stax/command/internal_command_move.dart';
import 'package:stax/command/internal_command_pr_creation.dart';
import 'package:stax/command/internal_command_pull.dart';
import 'package:stax/command/internal_command_rebase.dart';
import 'package:stax/command/internal_command_settings.dart';
import 'package:stax/command/internal_command_terminal.dart';
import 'package:stax/command/internal_command_update.dart';
import 'package:stax/command/internal_command_update_prompt.dart';
import 'package:stax/command/internal_command_version.dart';

final List<InternalCommand> internalCommands = [
  InternalCommandAbout(),
  InternalCommandAmend(),
  InternalCommandCommit(),
  InternalCommandDeleteStale(),
  InternalCommandDoctor(),
  InternalCommandGet(),
  InternalCommandHelp(),
  InternalCommandLog(),
  InternalCommandLogTestCase(),
  InternalCommandMainBranch(),
  InternalCommandMove(),
  InternalCommandPrCreation(),
  InternalCommandPull(),
  InternalCommandRebase(),
  InternalCommandSettings(),
  InternalCommandTerminal(),
  InternalCommandUpdate(),
  InternalCommandUpdatePrompt(),
  InternalCommandVersion(),
]..sort();
