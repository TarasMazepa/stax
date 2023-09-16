import 'dart:io';

import 'package:stax/git.dart';
import 'package:stax/process_result_print.dart';

import 'command.dart';

class DeleteGoneBranchesCommand extends Command {
  DeleteGoneBranchesCommand()
      : super(
            "delete-gone-branches", "deletes local branches with gone remotes");

  @override
  void run(List<String> args) {
    Git.fetch.announce().runSync().printNotEmptyResultFields();
    final gitBranches =
        Git.branches.announce().runSync().printNotEmptyResultFields();
    final branchesToDelete = gitBranches.stdout
        .toString()
        .split("\n")
        .where((element) =>
            element.isNotEmpty &&
            element[0] != "*" &&
            element.contains(": gone] "))
        .map((e) => e.substring(2, e.indexOf(" ", 2)))
        .toList();
    if (branchesToDelete.isEmpty) {
      print("No local branches with gone remotes.");
      return;
    }
    print("Local branches with gone remotes: ${branchesToDelete.join(", ")}.");
    stdout.write("Do you want to delete them all y/N? ");
    final answer = stdin.readLineSync();
    if (answer == 'y') {
      Process.runSync("git", ["branch", "-D", ...branchesToDelete])
          .printNotEmptyResultFields();
    }
  }
}
