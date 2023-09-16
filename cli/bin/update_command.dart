import 'dart:io';

import 'package:path/path.dart';

import 'command.dart';
import 'package:stax/process_result_print.dart';

class UpdateCommand extends Command {
  UpdateCommand() : super("update", "updates to the latest version");

  @override
  void run(List<String> args) {
    final executablePath = dirname(Platform.script.toFilePath());
    Process.runSync("git", ["pull"], workingDirectory: executablePath)
        .printNotEmpty();
  }
}
