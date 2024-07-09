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
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final direction = args.elementAtOrNull(0);

    if (direction == null) {
      context.printToConsole("Direction wasn't provided.");
      return;
    }

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

    GitLogAllNode? target = {
      "up": (int? index) => current.children.isEmpty
          ? current
          : current.sortedChildren.elementAtOrNull(index ?? 0),
      "down": (int? index) => current.parent ?? current,
      "top": (int? index) {
        var node = current.sortedChildren.elementAtOrNull(index ?? 0);
        while (node?.children.length == 1) {
          node = node?.children.first;
        }
        return node;
      },
      "bottom": (int? index) {
        final isRemoteHeadReachable = current.isRemoteHeadReachable();
        var node = current.parent;
        if (node == null) {
          return current;
        } else {
          while (node?.parent != null &&
              node?.parent?.isRemoteHeadReachable() == isRemoteHeadReachable &&
              node?.children.length == 1) {
            node = node?.parent;
          }
          return node;
        }
      },
      "head": (int? index) => current.findRemoteHead(),
    }
        .entries
        .fold<MapEntry<String, GitLogAllNode? Function(int?)>?>(
            null,
            (value, element) => element.key.startsWith(direction)
                ? element.key.length <=
                        (value?.key.length ?? element.key.length)
                    ? element
                    : value
                : value)
        ?.value(index);

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
