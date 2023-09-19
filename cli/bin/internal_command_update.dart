import 'dart:io';

import 'package:path/path.dart';
import 'package:stax/context_for_internal_command.dart';
import 'package:stax/shortcuts_for_internal_command_context.dart';

import 'internal_command.dart';

class InternalCommandUpdate extends InternalCommand {
  InternalCommandUpdate() : super("update", "Updates to the latest version.");

  @override
  void run(final ContextForInternalCommand context) {
    final executablePath = dirname(Platform.script.toFilePath());
    final currentBranch = context.getCurrentBranch();
    final mainBranch = "main";
    if (currentBranch != mainBranch) {
      final result = context.git.checkout
          .arg(mainBranch)
          .askContinueQuestion(
              "Switching from $currentBranch to $mainBranch branch.")
          ?.announce("Switching to $mainBranch.")
          .runSync(workingDirectory: executablePath)
          .printNotEmptyResultFields();
      if (result == null) return;
    }
    context.git.pull
        .announce("Pulling new changes.")
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields();
  }
}
