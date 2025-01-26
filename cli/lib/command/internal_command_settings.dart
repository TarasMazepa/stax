import 'package:collection/collection.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/setting.dart';

class InternalCommandSettings extends InternalCommand {
  late final availableSubCommands = [
    'set',
    'clear',
    'show',
  ].sorted();

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings',
          type: InternalCommandType.hidden,
          arguments: {
            'arg1': 'Subcommand (show, set,clear)',
            'opt2': 'Setting name (for show/set/clear)',
            'opt3': 'New value (for set)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    late final List<Setting> availableSettings = [
      context.settings.branchPrefix,
      context.settings.defaultBranch,
      context.settings.defaultRemote,
    ].sortedBy((setting) => setting.name);
    bool isSettingAvailable(String name) =>
        availableSettings.any((setting) => setting.name == name);
    Setting getSettingByName(String name) =>
        availableSettings.firstWhere((x) => x.name == name);
    void printAvailableSettings() {
      for (final setting in availableSettings) {
        context.printToConsole(
          " • ${setting.name} = '${setting.value}' # ${setting.description}",
        );
      }
    }

    switch (args) {
      case ['show']:
        context.printToConsole('Current settings:');
        printAvailableSettings();
      case ['show', ...]:
        context.printToConsole("'show' doesn't have arguments");
      case ['set', final name, final value] when isSettingAvailable(name):
        getSettingByName(name).value = value;
        context.printToConsole("Updated setting: $name = '$value'");
      case ['set', final name, _]:
        context.printToConsole(
          "set: unknown setting '$name'. Available settings:",
        );
        printAvailableSettings();
      case ['set', ...]:
        context
            .printToConsole('Usage: stax settings set <setting_name> <value>');
      case ['clear', final name] when isSettingAvailable(name):
        final setting = getSettingByName(name);
        setting.clear();
        context.printToConsole(
          'Cleared setting: ${setting.name} = ${setting.value}',
        );

      case ['clear', final name]:
        context.printToConsole(
          "clear: unknown setting '$name'. Available settings:",
        );
        printAvailableSettings();
      case ['clear', ...]:
        context.printToConsole('Usage: stax settings clear <setting_name>');

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
