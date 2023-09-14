import 'dart:io';

import 'package:path/path.dart';

import 'command.dart';
import 'package:stax/process_result_print.dart';

class UpdateCommand extends Command {
  const UpdateCommand() : super("update", "updates to the latest version");

  @override
  void run(List<String> args) {
    var executablePath = dirname(Platform.script.toFilePath());
    print(executablePath);
    Process.runSync("git", ["pull"],
            runInShell: true, workingDirectory: executablePath)
        .print();
  }
}
