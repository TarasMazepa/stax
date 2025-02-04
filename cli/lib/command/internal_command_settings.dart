import 'package:collection/collection.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/key_value_list_setting.dart';
import 'package:stax/settings/pair.dart';
import 'package:stax/settings/setting.dart';

class InternalCommandSettings extends InternalCommand {
  late final availableSubCommands = [
    'set',
    'clear',
    'show',
    'add',
    'remove',
  ].sorted();

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings',
          type: InternalCommandType.hidden,
          arguments: {
            'arg1': 'Subcommand (show, set, clear, add, remove)',
            'opt2': 'Setting name',
            'opt3': 'Value (for set/add/remove)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    late final List<Setting> availableSettings = <Setting>[
      context.settings.branchPrefix,
      context.settings.defaultBranch,
      context.settings.defaultRemote,
      context.settings.demo,
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
        getSettingByName(name).rawValue = value;
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

      case ['add', final name, final value] when isSettingAvailable(name):
        final setting = getSettingByName(name);
        if (setting is BaseListSetting) {
          if (setting is KeyValueListSetting) {
            setting.add(Pair.parseString(value));
          } else {
            setting.add(value);
          }
          context.printToConsole("Added '$value' to setting: $name");
        } else {
          context.printToConsole("Setting '$name' is not a list setting");
        }

      case ['remove', final name, final value] when isSettingAvailable(name):
        final setting = getSettingByName(name);
        if (setting is BaseListSetting) {
          if (setting is KeyValueListSetting) {
            setting.remove(Pair.parseString(value));
          } else {
            setting.remove(value);
          }
          context.printToConsole("Removed '$value' from setting: $name");
        } else {
          context.printToConsole("Setting '$name' is not a list setting");
        }

      case ['add', ...]:
        context
            .printToConsole('Usage: stax settings add <setting_name> <value>');

      case ['remove', ...]:
        context.printToConsole(
          'Usage: stax settings remove <setting_name> <value>',
        );

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
