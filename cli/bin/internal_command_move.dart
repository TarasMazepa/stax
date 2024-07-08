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

    final direction = args.elementAtOrNull(0);
    final rawIndex = args.elementAtOrNull(1);
    final int? index;
    if (rawIndex != null) {
      index = int.tryParse(rawIndex);
      if (index == null) {
        context.printToConsole("Can't parse '$rawIndex' as int.");
        return;
      }
    } else {
      index = null;
    }

    final root = context.withSilence(true).gitLogAll().collapse();

    if (root == null) {
      context.printToConsole("Can't find any nodes.");
      return;
    }

    final current = root.findCurrent();

    if (current == null) {
      context.printToConsole("Can find current node.");
      return;
    }

    GitLogAllNode? target;
    switch (direction) {
      case "up":
        if (current.children.isEmpty) {
          target = current;
        } else {
          target = current.sortedChildren.elementAtOrNull(index ?? 0);
        }
      case "down":
        if (current.parent == null) {
          target = current;
        } else {
          target = current.parent;
        }
      case "top":
        var node = current.sortedChildren.elementAtOrNull(index ?? 0);
        if (node == null) {
          target = current;
        } else {
          while (node?.children.length == 1) {
            node = node?.children.first;
          }
          target = node;
        }
      case "bottom":
        final isRemoteHeadReachable = current.isRemoteHeadReachable();
        bool moveDownAtLeastOnce = true;
        var node = current.parent;
        if (node == null) {
          target = current;
        } else {
          while (node?.parent != null &&
              (moveDownAtLeastOnce ||
                  node?.parent?.isRemoteHeadReachable() ==
                      isRemoteHeadReachable) &&
              node?.parent?.children.length == 1) {
            node = node?.parent;
            moveDownAtLeastOnce = false;
          }
          target = node;
        }
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
    if (target == current) {
      context.printToConsole("Looks like you are already there.");
      return;
    }
    context.git.checkout
        .arg(target.line.branchNameOrCommitHash())
        .announce()
        .runSync()
        .printNotEmptyResultFields();
  }
}
