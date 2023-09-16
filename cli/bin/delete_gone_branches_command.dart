import 'dart:io';

import 'package:stax/process_result_print.dart';

import 'command.dart';

class DeleteGoneBranchesCommand extends Command {
  DeleteGoneBranchesCommand()
      : super(
            "delete-gone-branches", "deletes local branches with gone remotes");

  @override
  void run(List<String> args) {
    Process.runSync("git", ["fetch", "-p"]).printNotEmpty();
    final gitBranches =
        Process.runSync("git", ["branch", "-vv"]).printNotEmpty();
    final branchesToDelete = gitBranches.stdout
        .toString()
        .split("\n")
        .where((element) =>
            element.isNotEmpty &&
            element[0] != "*" &&
            element.contains(": gone] "))
        .map((e) => e.substring(2, e.indexOf(" ", 2)))
        .toList();
    print("Local branches with gone remotes: ${branchesToDelete.join(", ")}.");
    stdout.write("Do you want to delete them all y/N? ");
    final answer = stdin.readLineSync();
    if (answer == 'y') {
      Process.runSync("git", ["branch", "-D", ...branchesToDelete])
          .printNotEmpty();
    }
  }
}
