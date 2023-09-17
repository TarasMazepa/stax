import 'package:stax/git.dart';
import 'package:stax/nullable_index_of.dart';
import 'package:stax/process_result_print.dart';

import 'command.dart';

class MainBranchCommand extends Command {
  MainBranchCommand()
      : super("main-branch", "Shows which branch stax considers to be main.");

  @override
  void run(List<String> args) {
    var a = Git.branch
        .announce()
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .split("\n")
        .where((element) => element.length > 2)
        .map((e) => e.substring(2, e.indexOf(" ", 2).toNullableIndexOfResult()))
        .toList()
        .map((e) => Git.revListCount
            .withArgument(e)
            .announce()
            .runSync()
            .printNotEmptyResultFields())
        .toList();
  }
}
