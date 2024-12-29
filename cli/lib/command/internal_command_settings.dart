import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandSettings extends InternalCommand {
  static const availableSettings = {
    'branch_prefix': 'Prefix to add to all new branch names (e.g., "feature/")',
  };

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings',
          type: InternalCommandType.hidden,
          arguments: {
            'arg1': 'Subcommand (set)',
            'opt2': 'Setting name (for set)',
            'opt3': 'New value (for set)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    // Initialize settings
    Settings.instance.branchPrefix;

    if (args.isEmpty) {
      context.printToConsole(
        'Usage: stax settings set <setting_name> <value>',
      );
      return;
    }

    final subcommand = args[0];
    switch (subcommand) {
      case 'set':
        _handleSet(args.skip(1).toList(), context);
      default:
        context.printToConsole(
          'Unknown subcommand: $subcommand\n'
          'Available subcommand: set',
        );
    }
  }

  void _handleSet(List<String> args, Context context) {
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
}
