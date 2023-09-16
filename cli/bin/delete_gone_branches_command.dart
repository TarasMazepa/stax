import 'dart:io';

import 'package:stax/process_result_print.dart';

import 'command.dart';

class DeleteGoneBranchesCommand extends Command {
  const DeleteGoneBranchesCommand()
      : super("delete-gone-branches",
            "deletes local branches that are tracking remote branches that are gone");

  @override
  void run(List<String> args) {
    Process.runSync("git", ["fetch", "-p"]).printNotEmpty();
    final branches = Process.runSync("git", ["branch", "-vv"]);
    branches.printNotEmpty();
  }
}
