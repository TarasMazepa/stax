import 'dart:io';

import 'package:stax/context_for_internal_command.dart';
import 'package:stax/file_path_dir_on_uri.dart';
import 'package:stax/settings/settings.dart';
import 'package:stax/shortcuts_for_internal_command_context.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandUpdatePrompt extends InternalCommand {
  InternalCommandUpdatePrompt()
      : super("update-prompt", "Asks about updating.",
            type: InternalCommandType.hidden);

  @override
  void run(ContextForInternalCommand context) {
    final lastUpdatePrompt = Settings.instance.lastUpdatePrompt.get();
    final now = DateTime.now();
    final silenceDuration = Duration(days: 1);
    if (lastUpdatePrompt.add(silenceDuration).isAfter(now)) return;
    Settings.instance.lastUpdatePrompt.set(now);
    final silentContext = ContextForInternalCommand.silent();
    final myDir = Platform.script.toFilePathDir();
    if (!silentContext.isCurrentBranchBehind(workingDirectory: myDir)) {
      // fetch
    }
  }
}
