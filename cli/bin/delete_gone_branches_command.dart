import 'dart:io';

import 'command.dart';

class DeleteGoneBranchesCommand extends Command {
  const DeleteGoneBranchesCommand()
      : super("delete-gone-branches",
            "deletes local branches that are tracking remote branches that are gone");

  @override
  void run(List<String> args) {
    Process.runSync("git", ["fetch", "-p"]);
  }
}
