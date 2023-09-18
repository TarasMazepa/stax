import 'dart:io';

import 'package:path/path.dart';

import 'context_for_internal_command.dart';
import 'internal_command.dart';

class InternalCommandUpdate extends InternalCommand {
  InternalCommandUpdate() : super("update", "Updates to the latest version.");

  @override
  void run(final ContextForInternalCommand context) {
    final executablePath = dirname(Platform.script.toFilePath());
    final currentBranch = context.git.branchCurrent
        .announce()
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim();
    final mainBranch = "main";
    if (currentBranch != mainBranch) {
      final result = context.git.checkout
          .arg(mainBranch)
          .askContinueQuestion(
              "Switching from $currentBranch to $mainBranch branch.")
          ?.announce()
          .runSync(workingDirectory: executablePath)
          .printNotEmptyResultFields();
      if (result == null) return;
    }
    context.git.pull
        .announce()
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields();
  }
}
