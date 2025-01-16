import 'package:collection/collection.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/settings/repository_settings.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandSettings extends InternalCommand {
  final globalSettings = [
    Settings.instance.branchPrefix,
    Settings.instance.defaultBranch,
    Settings.instance.defaultRemote,
  ].sortedBy((setting) => setting.name);

  final availableSubCommands = [
    'set',
    'clear',
    'show',
    'set-repo',
    'clear-repo',
    'show-repo',
  ].sorted();

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings (global and repository-specific)',
          type: InternalCommandType.hidden,
          arguments: {
            'arg1': 'Subcommand (show/set/clear/show-repo/set-repo/clear-repo)',
            'opt2': 'Setting name (for show/set/clear commands)',
            'opt3': 'New value (for set/set-repo commands)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    final repoSettings = context.isInsideWorkTree()
        ? RepositorySettings.getInstanceFromContext(context)
        : null;

    switch (args) {
      // Global settings commands
      case ['show']:
        context.printToConsole('Current global settings:');
        for (final setting in globalSettings) {
          context.printToConsole(
            " • ${setting.name} = '${setting.value}' # ${setting.description}",
          );
        }

      // Repository settings commands
      case ['show-repo']:
        if (repoSettings == null) {
          context.printToConsole('Not in a git repository');
          return;
        }
        context.printToConsole('Current repository settings:');
        for (final setting in globalSettings) {
          final repoValue = repoSettings[setting.name];
          context.printToConsole(
            " • ${setting.name} = ${repoValue ?? '(using global)'} # ${setting.description}",
          );
        }

      case ['set-repo', final name, final value]:
        if (repoSettings == null) {
          context.printToConsole('Not in a git repository');
          return;
        }
        if (globalSettings.any((setting) => setting.name == name)) {
          repoSettings[name] = value;
          repoSettings.save();
          context.printToConsole('Updated repository setting: $name = $value');
        } else {
          context.printToConsole(
              '''set-repo: unknown setting '$name'. Available settings:
${globalSettings.map((setting) => " • ${setting.name}").join("\n")}''');
        }

      case ['clear-repo', final name]:
        if (repoSettings == null) {
          context.printToConsole('Not in a git repository');
          return;
        }
        if (globalSettings.any((setting) => setting.name == name)) {
          repoSettings[name] = null;
          repoSettings.save();
          context.printToConsole(
            'Cleared repository setting: $name (using global value)',
          );
        } else {
          context.printToConsole(
              '''clear-repo: unknown setting '$name'. Available settings:
${globalSettings.map((setting) => " • ${setting.name}").join("\n")}''');
        }

      // Existing global settings cases
      case ['set', final name, final value]
          when globalSettings.any((setting) => setting.name == name):
        globalSettings.firstWhere((x) => x.name == name).value = value;
        context.printToConsole('Updated global setting: $name = $value');

      case ['clear', final name]
          when globalSettings.any((setting) => setting.name == name):
        final setting = globalSettings.firstWhere((x) => x.name == name);
        setting.clear();
        context.printToConsole(
          'Cleared global setting: ${setting.name} = ${setting.value}',
        );

      // Error cases
      case ['set', final name, _]:
        context
            .printToConsole('''set: unknown setting '$name'. Available settings:
${globalSettings.map((setting) => " • ${setting.name}").join("\n")}''');

      case ['clear', final name]:
        context.printToConsole(
            '''clear: unknown setting '$name'. Available settings:
${globalSettings.map((setting) => " • ${setting.name}").join("\n")}''');

      case ['show', ...]:
        context.printToConsole("'show' doesn't have arguments");

      case ['set', ...]:
        context
            .printToConsole('Usage: stax settings set <setting_name> <value>');

      case ['clear', ...]:
        context.printToConsole('Usage: stax settings clear <setting_name>');

      case ['set-repo', ...]:
        context.printToConsole(
          'Usage: stax settings set-repo <setting_name> <value>',
        );

      case ['clear-repo', ...]:
        context
            .printToConsole('Usage: stax settings clear-repo <setting_name>');

      case [final subCommand, ...]:
        context.printToConsole(
            '''Unknown sub-command '$subCommand'. Available sub-commands:
${availableSubCommands.map((subCommand) => " • $subCommand").join("\n")}''');

      case []:
      default:
        context.printToConsole(
            '''Please provide sub-command. Available sub-commands:
${availableSubCommands.map((subCommand) => " • $subCommand").join("\n")}''');
    }
  }
}
