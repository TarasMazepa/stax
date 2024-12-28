import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';
import 'package:stax/settings/string_setting.dart';

class InternalCommandSettings extends InternalCommand {
  static const availableSettings = {
    'branch_prefix': 'Prefix to add to all new branch names (e.g., "feature/")',
  };

  static const _subcommands = {
    'show': 'Display current settings',
    'set': 'Set a setting value',
    'clear': 'Clear a setting value',
  };

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings',
          type: InternalCommandType.hidden,
          arguments: {
            'arg1': 'Subcommand (${_subcommands.keys.join(", ")})',
            'opt2': 'Setting name (for set/clear)',
            'opt3': 'New value (for set)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    // Initialize settings
    Settings.instance.branchPrefix;

    if (args.isEmpty) {
      _showHelp(context);
      return;
    }

    final subcommand = args[0];
    final remainingArgs = args.skip(1).toList();

    switch (subcommand) {
      case 'show':
        _showSettings(context);
      case 'set':
        _setSetting(remainingArgs, context);
      case 'clear':
        _clearSetting(remainingArgs, context);
      default:
        context.printToConsole(
          'Unknown subcommand: $subcommand\n'
          'Available subcommands: ${_subcommands.keys.join(", ")}',
        );
    }
  }

  void _showHelp(Context context) {
    context.printToConsole('Available subcommands:');
    for (final entry in _subcommands.entries) {
      context.printToConsole('  ${entry.key}: ${entry.value}');
    }
    context.printToConsole('\nAvailable settings:');
    for (final setting in availableSettings.entries) {
      context.printToConsole('  ${setting.key}: ${setting.value}');
    }
  }

  void _showSettings(Context context) {
    context.printToConsole('Current settings:');
    for (final setting in availableSettings.entries) {
      final currentValue = Settings.instance[setting.key];
      context.printToConsole(
        '${setting.key}: ${currentValue ?? "<not set>"}'
        '\n  ${setting.value}',
      );
    }
  }

  void _setSetting(List<String> args, Context context) {
    if (args.length < 2) {
      context.printToConsole(
        'Usage: stax settings set <setting_name> <value>',
      );
      return;
    }

    final settingName = args[0];
    final newValue = args[1];

    if (!availableSettings.containsKey(settingName)) {
      context.printToConsole(
        'Unknown setting: $settingName\n'
        'Available settings: ${availableSettings.keys.join(", ")}',
      );
      return;
    }

    Settings.instance[settingName] = newValue;
    Settings.instance.save();
    context.printToConsole('Updated setting: $settingName = $newValue');
  }

  void _clearSetting(List<String> args, Context context) {
    if (args.isEmpty) {
      context.printToConsole(
        'Usage: stax settings clear <setting_name>',
      );
      return;
    }

    final settingName = args[0];

    if (!availableSettings.containsKey(settingName)) {
      context.printToConsole(
        'Unknown setting: $settingName\n'
        'Available settings: ${availableSettings.keys.join(", ")}',
      );
      return;
    }

    Settings.instance[settingName] = null;
    Settings.instance.save();
    context.printToConsole('Cleared setting: $settingName');
  }
}
