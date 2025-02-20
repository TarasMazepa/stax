import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

sealed class MoveDirection {
  final args = <String>[];
}

class UpMoveDirection extends MoveDirection {
  int index;

  UpMoveDirection([this.index = 0]);
}

class TopMoveDirection extends MoveDirection {
  int index;

  TopMoveDirection([this.index = 0]);
}

class DownMoveDirection extends MoveDirection {}

class BottomMoveDirection extends MoveDirection {}

class HeadMoveDirection extends MoveDirection {}

class InternalCommandMove extends InternalCommand {
  InternalCommandMove()
      : super(
          'move',
          "Allows you to move around log tree. Note: you can type any amount of first letters to specify direction. 'h' instead of 'head', 't' for 'top, 'd' for down, 'u' for 'up', 'b' for 'bottom'",
          arguments: {
            '[arg]+':
                'up (one up, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), down (one down), top (to the closest top parent that have at least two children or to the top most node, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), bottom (to the closest bottom parent that have at least two children or bottom most node, will stop before any direct parent of <remote>/head), head (<remote>/head)',
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final moveDirections = <MoveDirection>[];
    for (var arg in args) {
      final index = int.tryParse(arg);
      if (index != null) {
        final last = moveDirections.lastOrNull;
        if (last case UpMoveDirection _ when last.index == 0) {
          last.index = index;
          last.args.add(arg);
        } else if (last case TopMoveDirection _ when last.index == 0) {
          last.index = index;
          last.args.add(arg);
        } else {
          context.printParagraph(
            "'$arg' index provided without leading 'up' or 'top' direction",
          );
          return;
        }
      } else if ('up'.startsWith(arg)) {
        moveDirections.add(UpMoveDirection()..args.add(arg));
      } else if ('top'.startsWith(arg)) {
        moveDirections.add(TopMoveDirection()..args.add(arg));
      } else if ('bottom'.startsWith(arg)) {
        moveDirections.add(BottomMoveDirection()..args.add(arg));
      } else if ('down'.startsWith(arg)) {
        moveDirections.add(DownMoveDirection()..args.add(arg));
      } else if ('head'.startsWith(arg)) {
        moveDirections.add(HeadMoveDirection()..args.add(arg));
      } else {
        context.printParagraph("Unknown direction provided '$arg'");
        return;
      }
    }

    if (moveDirections.isEmpty) {
      context.printParagraph("Direction wasn't provided.");
      return;
    }

    final root = context.gitLogAll();

    final current = root.findCurrent();

    if (current == null) {
      context.printToConsole('Can find current node.');
      return;
    }

    GitLogAllNode? target = current;
    for (var moveDirection in moveDirections) {
      switch (moveDirection) {
        case UpMoveDirection up:
          target = target?.children.elementAtOrNull(up.index);
        case TopMoveDirection top:
          target = target?.children.elementAtOrNull(top.index);
          while (target?.children.length == 1) {
            target = target?.children.elementAtOrNull(0);
          }
        case DownMoveDirection _:
          target = target?.parent;
        case BottomMoveDirection _:
          final isRemoteHeadReachable = target?.isRemoteHeadReachable() == true;
          target = target?.parent;
          if (isRemoteHeadReachable) {
            while (target?.parent != null && target?.children.length == 1) {
              target = target?.parent;
            }
          } else {
            while (target?.parent != null &&
                target?.parent?.isRemoteHeadReachable() != true &&
                target?.children.length == 1) {
              target = target?.parent;
            }
          }
        case HeadMoveDirection _:
          target = root.findRemoteHead();
      }
      if (target == null) {
        context.printParagraph(
            "Can't find target node with ${moveDirection.args.map(
                  (e) => "'$e'",
                ).join(", ")}.");
        return;
      }
    }

    if (target == null) {
      context.printParagraph("Can't find target node with ${args.map(
            (e) => "'$e'",
          ).join(", ")}.");
      return;
    }

    if (target == current) {
      context.printToConsole('Looks like you are already there.');
      return;
    }

    context.git.checkout
        .arg(target.line.branchNameOrCommitHash())
        .announce()
        .runSync()
        .printNotEmptyResultFields();
  }
}
