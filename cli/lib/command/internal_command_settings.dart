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
            'arg1': 'Subcommand (set, clear)',
            'opt2': 'Setting name',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    // Initialize settings
    Settings.instance.branchPrefix;

    if (args.isEmpty) {
      context.printToConsole(
        'Usage: stax settings <subcommand>\n'
        'Available subcommands: set, clear',
      );
      return;
    }

    final subcommand = args[0];
    switch (subcommand) {
      case 'set':
        _handleSet(args.skip(1).toList(), context);
      case 'clear':
        _handleClear(args.skip(1).toList(), context);
      default:
        context.printToConsole(
          'Unknown subcommand: $subcommand\n'
          'Available subcommands: set, clear',
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

  void _handleClear(List<String> args, Context context) {
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
