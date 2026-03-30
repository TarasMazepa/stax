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

class LeftMoveDirection extends MoveDirection {}

class RightMoveDirection extends MoveDirection {}

class InternalCommandMove extends InternalCommand {
  InternalCommandMove()
    : super(
        'move',
        "Allows you to move around log tree. Note: you can type any amount of first letters to specify direction. 'h' instead of 'head', 't' for 'top, 'd' for down, 'u' for 'up', 'b' for 'bottom', 'l' for 'left', 'r' for 'right'",
        arguments: {
          '[arg]+':
              'up (one up, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), down (one down), left (previous sibling node), right (next sibling node), top (to the closest top parent that have at least two children or to the top most node, optionally you can provide followup argument which would be a 0-based index of the child you want to move, by default it is 0), bottom (to the closest bottom parent that have at least two children or bottom most node, will stop before any direct parent of <remote>/head), head (<remote>/head)',
        },
      );

  @override
  Future<void> run(List<String> args, Context context) async {
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
      } else if ('left'.startsWith(arg)) {
        moveDirections.add(LeftMoveDirection()..args.add(arg));
      } else if ('right'.startsWith(arg)) {
        moveDirections.add(RightMoveDirection()..args.add(arg));
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
          target = target?.sortedChildren.elementAtOrNull(up.index);
        case TopMoveDirection top:
          target = target?.sortedChildren.elementAtOrNull(top.index);
          while (target?.children.length == 1) {
            target = target?.sortedChildren.elementAtOrNull(0);
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
        case LeftMoveDirection _:
          final parent = target?.parent;
          if (parent != null) {
            final children = parent.sortedChildren;
            final currentIndex = children.indexOf(target!);
            if (currentIndex > 0) {
              target = children[currentIndex - 1];
            } else {
              target = null;
            }
          } else {
            target = null;
          }
        case RightMoveDirection _:
          final parent = target?.parent;
          if (parent != null) {
            final children = parent.sortedChildren;
            final currentIndex = children.indexOf(target!);
            if (currentIndex >= 0 && currentIndex < children.length - 1) {
              target = children[currentIndex + 1];
            } else {
              target = null;
            }
          } else {
            target = null;
          }
      }
      if (target == null) {
        context.printParagraph(
          "Can't find target node with ${moveDirection.args.map((e) => "'$e'").join(", ")}.",
        );
        return;
      }
    }

    if (target == null) {
      context.printParagraph(
        "Can't find target node with ${args.map((e) => "'$e'").join(", ")}.",
      );
      return;
    }

    if (target == current) {
      context.printToConsole('Looks like you are already there.');
      return;
    }

    final localBranchName = target.line.localBranchNames().firstOrNull;
    final remoteBranchName = target.line.remoteBranchNames().firstOrNull;
    if (localBranchName != null) {
      (await context.git.switch0.arg(localBranchName).announce().run())
          .printNotEmptyResultFields();
    } else if (remoteBranchName != null) {
      final branchToRecreate = remoteBranchName.substring(
        remoteBranchName.indexOf('/') + 1,
      );
      (await context.git.switch0
              .arg('-C')
              .arg(branchToRecreate)
              .arg(target.line.commitHash)
              .announce()
              .run())
          .printNotEmptyResultFields();
    } else {
      (await context.git.switchDetach
              .arg(target.line.commitHash)
              .announce()
              .run())
          .printNotEmptyResultFields();
    }
  }
}
