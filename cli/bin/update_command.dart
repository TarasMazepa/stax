import 'dart:io';

import 'package:path/path.dart';
import 'package:stax/git.dart';

import 'command.dart';

class UpdateCommand extends Command {
  UpdateCommand() : super("update", "Updates to the latest version.");

  @override
  void run(List<String> args) {
    final executablePath = dirname(Platform.script.toFilePath());
    final currentBranch = Git.branchCurrent
        .announce()
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim();
    final mainBranch = "main";
    if (currentBranch != mainBranch) {
      final result = Git.checkout
          .withArgument(mainBranch)
          .askContinueQuestion(
              "Switching from $currentBranch to $mainBranch branch.")
          ?.announce()
          .runSync(workingDirectory: executablePath)
          .printNotEmptyResultFields();
      if (result == null) return;
    }
    Git.pull
        .announce()
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields();
  }
}
