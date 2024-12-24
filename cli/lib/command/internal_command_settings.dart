import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandSettings extends InternalCommand {
  // Define available settings with descriptions
  static const availableSettings = {
    'branch_prefix': 'Prefix to add to all new branch names (e.g., "feature/")',
    // Add other settings here as they become available
  };

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings',
          type: InternalCommandType.hidden,
          arguments: {
            'opt1': 'Setting name to modify',
            'opt2': 'New value (omit to clear the setting)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    if (args.isEmpty) {
      // Display all settings
      context.printToConsole('Available settings:');
      for (final setting in availableSettings.entries) {
        final currentValue = Settings.instance.settings[setting.key];
        context.printToConsole(
          '${setting.key}: ${currentValue ?? "<not set>"}'
          '\n  ${setting.value}',
        );
      }
      return;
    }

    final settingName = args[0];

    // Validate setting name
    if (!availableSettings.containsKey(settingName)) {
      context.printToConsole(
        'Unknown setting: $settingName\n'
        'Available settings: ${availableSettings.keys.join(", ")}',
      );
      return;
    }

    final newValue = args.length > 1 ? args[1] : null;

    if (newValue == null) {
      // Clear setting
      Settings.instance.removeSetting(settingName);
      context.printToConsole('Cleared setting: $settingName');
    } else {
      // Set new value
      Settings.instance.setSetting(settingName, newValue);
      context.printToConsole('Updated setting: $settingName = $newValue');
    }
  }
}
