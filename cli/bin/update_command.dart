import 'dart:io';

import 'package:path/path.dart';
import 'package:stax/git.dart';
import 'package:stax/process_result_print.dart';

import 'command.dart';

class UpdateCommand extends Command {
  UpdateCommand() : super("update", "updates to the latest version");

  @override
  void run(List<String> args) {
    final executablePath = dirname(Platform.script.toFilePath());
    Git.branchCurrent
        .announce()
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields();
    Git.pull
        .announce()
        .runSync(workingDirectory: executablePath)
        .printNotEmptyResultFields();
  }
}
