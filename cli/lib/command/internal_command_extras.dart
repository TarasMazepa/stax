import 'package:collection/collection.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_about.dart';
import 'package:stax/command/internal_command_changelog.dart';
import 'package:stax/command/internal_command_doctor.dart';
import 'package:stax/command/internal_command_help.dart';
import 'package:stax/command/internal_command_settings.dart';
import 'package:stax/command/internal_command_update.dart';
import 'package:stax/command/internal_command_version.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_handle_global_flags.dart';

class InternalCommandExtras extends InternalCommand {
  final List<InternalCommand> _extraCommands = [
    InternalCommandAbout(),
    InternalCommandChangelog(),
    InternalCommandDoctor(),
    InternalCommandHelp(),
    InternalCommandSettings(),
    InternalCommandUpdate(),
    InternalCommandVersion(),
  ]..sort();

  InternalCommandExtras()
    : super(
        'extras',
        'Extra non-primary commands.',
        arguments: {
          'arg1': 'Subcommand to run',
        },
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    switch (args) {
      case ['help']:
      case []:
        context.printToConsole('Here are available extra commands:');
        for (final command in _extraCommands) {
          context.printToConsole(
            ' • ${command.name}${command.shortName != null ? ", ${command.shortName}" : ""} - ${command.description}',
          );
        }
      case [final commandName, ...final commandArgs]:
        final command =
            _extraCommands.firstWhereOrNull(
              (command) =>
                  command.name == commandName ||
                  command.shortName == commandName,
            ) ??
            _extraCommands.fold<InternalCommand?>(
              null,
              (current, command) => switch (command) {
                _ when !command.name.startsWith(commandName) => current,
                _ when current == null => command,
                _ when current.name.length > command.name.length => command,
                _ when current.name.length < command.name.length => current,
                _ => current,
              },
            );

        if (command == null) {
          context.printParagraph(
            "Unknown extra command or prefix of a command '$commandName'.",
          );
          return;
        }

        if (context.hasHelpFlag(commandArgs)) {
          // If the extra command has its own help, we can call it.
          // Or we can just fallback to the global help.
          // The main help expects the command name as arg if we want specific help.
          await InternalCommandHelp().run([command.name], context);
        } else {
          await command.run(commandArgs, context);
        }
    }
  }
}
