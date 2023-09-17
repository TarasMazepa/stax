import 'package:stax/git.dart';
import 'package:stax/nullable_index_of.dart';
import 'package:stax/process_result_print.dart';

import 'command.dart';

class DeleteGoneBranchesCommand extends Command {
  DeleteGoneBranchesCommand()
      : super("delete-gone-branches",
            "Deletes local branches with gone remotes.");

  @override
  void run(List<String> args) {
    Git.fetchWithPrune.announce().runSync().printNotEmptyResultFields();
    final branchesToDelete = Git.branchVv
        .announce()
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .where((element) => element.length > 2)
        .where((element) => element[0] != "*" && element.contains(": gone] "))
        .map((e) => e.substring(2, e.indexOf(" ", 2).toNullableIndexOfResult()))
        .toList();
    if (branchesToDelete.isEmpty) {
      print("No local branches with gone remotes.");
      return;
    }
    Git.branchDelete
        .withArguments(branchesToDelete)
        .askContinueQuestion(
            "Local branches with gone remotes that would be deleted: ${branchesToDelete.join(", ")}.")
        ?.announce()
        .runSync()
        .printNotEmptyResultFields();
  }
}
