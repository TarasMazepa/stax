import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_about.dart';
import 'package:stax/command/internal_command_changelog.dart';
import 'package:stax/command/internal_command_doctor.dart';
import 'package:stax/command/internal_command_finder.dart';
import 'package:stax/command/internal_command_log_test_case.dart';
import 'package:stax/command/internal_command_main_branch.dart';
import 'package:stax/command/internal_command_nuke.dart';
import 'package:stax/command/internal_command_pull_get_rebase.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_command_settings.dart';
import 'package:stax/command/internal_command_terminal.dart';
import 'package:stax/command/internal_command_update.dart';
import 'package:stax/command/internal_command_update_prompt.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/command/internal_command_agents.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

final List<InternalCommand> extraCommands = [
  InternalCommandAbout(),
  InternalCommandChangelog(),
  InternalCommandDoctor(),
  InternalCommandLogTestCase(),
  InternalCommandMainBranch(),
  InternalCommandNuke(),
  InternalCommandPullGetRebase(),
  InternalCommandSettings(),
  InternalCommandTerminal(),
  InternalCommandUpdate(),
  InternalCommandUpdatePrompt(),
  InternalCommandVersion(),
  InternalCommandAgents(),
]..sort();

class InternalCommandExtras extends InternalCommand {
  InternalCommandExtras()
    : super(
        'extras',
        'Extra non-primary commands (${extraCommands.where((c) => c.type.isPublic).map((c) => c.name).join(', ')}). Run `stax extras` to see detailed list.',
        shortName: 'e',
        arguments: {'arg1': 'Subcommand to run'},
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    switch (args) {
      case []:
      case ['help']:
        await InternalCommandHelp().run(['extras'], context);
      case [final commandName, 'help', ...final commandArgs]:
      case [final commandName, ...final commandArgs]
          when context.hasHelpFlag(commandArgs):
        await InternalCommandHelp().run([
          'extras',
          commandName,
          ...commandArgs,
        ], context);
      case [final commandName, ...final commandArgs]:
        final command = extraCommands.findByNameOrPrefix(commandName);

        if (command == null) {
          context.printParagraph(
            "Unknown extra command or prefix of a command '$commandName'. Available commands: ${extraCommands.map((c) => c.name).join(', ')}",
          );
          return;
        }

        await command.run(commandArgs, context);
    }
  }
}
