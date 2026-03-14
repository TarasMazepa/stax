import 'package:collection/collection.dart';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/base_list_setting.dart';
import 'package:stax/settings/key_value_list_setting.dart';
import 'package:stax/settings/setting.dart';

class InternalCommandSettings extends InternalCommand {
  static final availableSubCommands = [
    'set',
    'clear',
    'show',
    'add',
    'remove',
  ].sorted();
  static final globalFlag = Flag(
    short: '-g',
    long: '--global',
    description:
        'Perform operation on global settings regardless of invocation path.',
  );

  InternalCommandSettings()
    : super(
        'settings',
        'View or modify stax settings',
        type: InternalCommandType.hidden,
        arguments: {
          'arg1': 'Subcommand (${availableSubCommands.join(', ')})',
          'opt2': 'Setting name',
          'opt3': 'Setting value',
        },
        flags: [globalFlag],
      );

  @override
  Future<void> run(final List<String> args, final Context context) async {
    final effectiveSettings = globalFlag.hasFlag(args)
        ? context.settings
        : context.effectiveSettings;
    late final List<Setting> availableSettings = <Setting>[
      effectiveSettings.additionallyPull,
      effectiveSettings.baseBranchReplacement,
      effectiveSettings.branchNameSymbolSanitizationRegEx,
      effectiveSettings.branchPrefix,
      effectiveSettings.defaultBranch,
      effectiveSettings.defaultRemote,
    ].sortedBy((setting) => setting.name);
    bool isSettingAvailable(String name) =>
        availableSettings.any((setting) => setting.name == name);
    Setting getSettingByName(String name) =>
        availableSettings.firstWhere((x) => x.name == name);
    void printAvailableSettings() {
      for (final setting in availableSettings) {
        context.printToConsole('''
# ${setting.description}

${setting.name} = '${setting.rawValue}'

''');
      }
    }

    void onUnknownSetting(String name) {
      context.printToConsole(
        "set: unknown setting '$name'. Available settings:\n",
      );
      printAvailableSettings();
    }

    switch (args) {
      case ['show']:
        printAvailableSettings();
      case ['show', ...]:
        context.printToConsole("'show' doesn't have arguments");
      case ['set', final name, final value] when isSettingAvailable(name):
        getSettingByName(name).value = value;
        context.printToConsole("Updated setting: $name = '$value'");
      case ['set', final name, _]:
        onUnknownSetting(name);
      case ['set', ...]:
        context.printToConsole(
          'Usage: stax settings set <setting_name> <value>',
        );
      case ['clear', final name] when isSettingAvailable(name):
        final setting = getSettingByName(name);
        setting.clear();
        context.printToConsole(
          'Cleared setting: ${setting.name} = ${setting.value}',
        );
      case ['clear', final name]:
        onUnknownSetting(name);
      case ['clear', ...]:
        context.printToConsole('Usage: stax settings clear <setting_name>');
      case ['add', final name, final value] when isSettingAvailable(name):
        final setting = getSettingByName(name);
        switch (setting) {
          case KeyValueListSetting s:
            s.addRaw(value);
            context.printToConsole(
              "Added key-value '$value' to setting: $name",
            );
          case BaseListSetting s:
            s.add(value);
            context.printToConsole("Added value '$value' to setting: $name");
          default:
            context.printToConsole(
              "Setting '$name' is not a list setting. Use 'set' instead.",
            );
        }
      case ['add', final name, _]:
        onUnknownSetting(name);
      case ['add', ...]:
        context.printToConsole(
          'Usage: stax settings add <setting_name> <value>',
        );
      case ['remove', final name, final value] when isSettingAvailable(name):
        final setting = getSettingByName(name);
        switch (setting) {
          case KeyValueListSetting s:
            final key = value.split('=').first;
            s.removeByKey(key);
            context.printToConsole(
              "Removed key-value with key '$key' from setting: $name",
            );
          case BaseListSetting s:
            s.remove(value);
            context.printToConsole(
              "Removed value '$value' from setting: $name",
            );
          default:
            context.printToConsole(
              "Setting '$name' is not a list setting. Use 'clear' instead.",
            );
        }
      case ['remove', final name, _]:
        onUnknownSetting(name);
      case ['remove', ...]:
        context.printToConsole(
          'Usage: stax settings remove <setting_name> <value>',
        );
      case [final subCommand, ...]:
        context.printToConsole(
          '''Unknown sub-command '$subCommand'. Available sub-commands:
${availableSubCommands.map((subCommand) => " • $subCommand").join("\n")}''',
        );
      case []:
      default:
        context.printToConsole(
          '''Please provide sub-command. Available sub-commands:
${availableSubCommands.map((subCommand) => " • $subCommand").join("\n")}''',
        );
    }
  }
}
