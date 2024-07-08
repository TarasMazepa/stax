import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandMove extends InternalCommand {
  InternalCommandMove()
      : super(
          "move",
          "Allows you to move around log tree.",
          type: InternalCommandType.hidden,
          arguments: {
            "arg1":
                "up (one up), down (one down), top (to the closest top parent that have at least two children or to the top most node), bottom (to the closest bottom parent that have at least two children or bottom most node), head (<remote>/head)",
            "opt2":
                "when using 'up' or 'top' as arg1, you can specify index of the child which would be selected for the current node.",
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    final root = context.withSilence(true).gitLogAll().collapse();

    if (root == null) {
      context.printToConsole("Can't find any branches.");
      return;
    }

    final current = root.findCurrent();

    if (current == null) {
      context.printToConsole("Can find current branch.");
      return;
    }

    final direction = args.elementAtOrNull(0);
    final index = args.elementAtOrNull(1);

    GitLogAllNode? target;
    switch (direction) {
      case "up":
        target =
            current.children.elementAtOrNull(int.tryParse(index ?? "0") ?? 0);
      case "down":
        target = current.parent;
      case "top":
        var node =
            current.children.elementAtOrNull(int.tryParse(index ?? "0") ?? 0);
        while (node?.children.length == 1) {
          node = node?.children.first;
        }
        target = node;
      case "bottom":
        var node = current.parent;
        while (node?.children.length == 1 && node?.parent != null) {
          node = node?.parent;
        }
        target = node;
      case "head":
        target = root.findRemoteHead();
      default:
        context.printToConsole("unknown direction '$direction'");
        return;
    }
    if (target == null) {
      context.printToConsole(
          "Can't find target node with '$direction' direction${index == null ? "" : " and '$index' index"}.");
      return;
    }
    context.git.checkout
        .arg(target.line.branchNameOrCommitHash())
        .announce()
        .runSync()
        .printNotEmptyResultFields();
  }
}
