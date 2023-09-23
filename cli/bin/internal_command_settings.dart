import 'package:stax/context/context_for_internal_command.dart';
import 'package:stax/settings/settings.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandSettings extends InternalCommand {
  InternalCommandSettings()
      : super("settings", "View stax settings",
            type: InternalCommandType.hidden);

  @override
  void run(ContextForInternalCommand context) {
    for (final entry in Settings.instance.settings.entries) {
      context.context.printToConsole("${entry.key}: ${entry.value}");
    }
  }
}
