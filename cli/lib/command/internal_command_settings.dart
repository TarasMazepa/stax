import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandSettings extends InternalCommand {
  final availableSettings = [
    Settings.instance.branchPrefix,
  ];

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
    switch (args) {
      case ['set', final name, final value]:
        final command = availableSettings.firstWhere(
          (x) => x.name == name,
          orElse: () => availableSettings[0],
        );
        if (command.name != name) {
          context.printToConsole(
            'Unknown setting: $name\n'
            'Available settings: ${availableSettings.map((s) => '${s.name} - ${s.description}').join(", ")}',
          );
          return;
        }
        command.set(value);
        context.printToConsole('Updated setting: $name = $value');
      default:
        context.printToConsole(
          'Usage: stax settings set <setting_name> <value>',
        );
    }
  }
}
