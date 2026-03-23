import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_amend.dart';
import 'package:stax/command/internal_command_commit.dart';
import 'package:stax/command/internal_command_delete_stale.dart';
import 'package:stax/command/internal_command_extras.dart';
import 'package:stax/command/internal_command_get.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_command_log.dart';
import 'package:stax/command/internal_command_move.dart';
import 'package:stax/command/internal_command_pr_creation.dart';
import 'package:stax/command/internal_command_pull.dart';
import 'package:stax/command/internal_command_rebase.dart';

final List<InternalCommand> internalCommands = [
  InternalCommandAmend(),
  InternalCommandCommit(),
  InternalCommandDeleteStale(),
  InternalCommandExtras(),
  InternalCommandGet(),
  InternalCommandHelp(),
  InternalCommandLog(),
  InternalCommandMove(),
  InternalCommandPrCreation(),
  InternalCommandPull(),
  InternalCommandRebase(),
]..sort();
