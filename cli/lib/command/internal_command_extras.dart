import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_about.dart';
import 'package:stax/command/internal_command_changelog.dart';
import 'package:stax/command/internal_command_doctor.dart';
import 'package:stax/command/internal_command_finder.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_command_settings.dart';
import 'package:stax/command/internal_command_update.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

class InternalCommandExtras extends InternalCommand {
  final List<InternalCommand> extraCommands = [
    InternalCommandAbout(),
    InternalCommandChangelog(),
    InternalCommandDoctor(),
    InternalCommandSettings(),
    InternalCommandUpdate(),
    InternalCommandVersion(),
  ]..sort();

  InternalCommandExtras()
    : super(
        'extras',
        'Extra non-primary commands (about, changelog, doctor, settings, update, version). Run `stax extras` to see detailed list.',
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
        await InternalCommandHelp().run([
          'extras',
          commandName,
          ...commandArgs,
        ], context);
      case [final commandName, ...final commandArgs]
          when context.hasHelpFlag(commandArgs):
        final command = extraCommands.findByNameOrPrefix(commandName);

        if (command == null) {
          context.printParagraph(
            "Unknown extra command or prefix of a command '$commandName'. Available commands: ${extraCommands.map((c) => c.name).join(', ')}",
          );
          return;
        }

        // If the extra command has its own help, we can call it.
        // Or we can just fallback to the global help.
        // The main help expects the command name as arg if we want specific help.
        await InternalCommandHelp().run([
          'extras',
          command.name,
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
