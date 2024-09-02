import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandSettings extends InternalCommand {
  InternalCommandSettings()
      : super(
          'settings',
          'View stax settings',
          type: InternalCommandType.hidden,
        );

  @override
  void run(final List<String> args, final Context context) {
    for (final entry in Settings.instance.settings.entries) {
      context.printToConsole('${entry.key}: ${entry.value}');
    }
  }
}
