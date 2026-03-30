import 'package:stax/base/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_delete_stale.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/external_command/extended_process_result.dart';
import 'package:stax/git/branch_info.dart';

class InternalCommandPull extends InternalCommand {
  static final stayOnHeadFlag = Flag(
    short: '-n',
    long: '--no-switch-back',
    description: 'Stay on the head/default branch after pulling.',
  );

  InternalCommandPull()
    : super(
        'pull',
        'Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.',
        shortName: 'p',
        arguments: {
          'opt1': 'Optional target branch, will default to <remote>/HEAD',
        },
        flags: [
          InternalCommandDeleteStale.forceDeleteFlag,
          stayOnHeadFlag,
          InternalCommandDeleteStale.skipDeleteFlag,
        ],
      );

  @override
  Future<void> run(List<String> args, Context context) async {
    if (await context.handleNotInsideGitWorkingTree()) {
      return;
    }
    final hasSkipDeleteFlag = InternalCommandDeleteStale.skipDeleteFlag.hasFlag(
      args,
    );
    final hasForceDeleteFlag = InternalCommandDeleteStale.forceDeleteFlag
        .hasFlag(args);
    final hasStayOnHeadFlag = stayOnHeadFlag.hasFlag(args);
    final currentBranch = await context.getCurrentBranch();
    final targetBranch = args.elementAtOrNull(0);
    final defaultBranch = targetBranch ?? context.getDefaultBranch();
    if (defaultBranch == null) {
      context.printToConsole(
        "Can't do pull on default branch, as can't identify one.",
      );
      return;
    }

    final additionalBranches = context.effectiveSettings.additionallyPull.value;

    bool needToSwitchBranches = currentBranch != defaultBranch;
    ExtendedProcessResult? result;
    if (needToSwitchBranches) {
      result =
          (await context.git.switch0
                  .arg(defaultBranch)
                  .announce("Switching to default branch '$defaultBranch'.")
                  .run())
              .printNotEmptyResultFields()
              .assertSuccessfulExitCode();
      if (result == null) return;
    }
    result =
        (await context.git.pullPrune
                .announce('Pulling new changes.')
                .run(onDemandPrint: true))
            .printNotEmptyResultFields()
            .assertSuccessfulExitCode();
    if (result == null) {
      if (!hasStayOnHeadFlag && needToSwitchBranches && currentBranch != null) {
        (await context.git.switch0
                .arg(currentBranch)
                .announce("Switching back to original branch '$currentBranch'.")
                .run())
            .printNotEmptyResultFields();
      }
      return;
    }

    for (final branch in additionalBranches) {
      if (branch.isNotEmpty) {
        (await context.git.switch0
                .arg(branch)
                .announce("Switching to additional branch '$branch'.")
                .run())
            .printNotEmptyResultFields();

        (await context.git.pullPrune
                .announce("Pulling changes for branch '$branch'.")
                .run(onDemandPrint: true))
            .printNotEmptyResultFields();
      }
    }

    final branchesToDelete =
        (await context.git.branchVv
                .announce('Checking if any remote branches are gone.')
                .run())
            .printNotEmptyResultFields()
            .parseBranchInfo()
            .where((e) => e.gone)
            .map((e) => e.name)
            .toList();
    if (branchesToDelete.isEmpty) {
      context.printToConsole('No local branches with gone remotes.');
    } else {
      final result =
          (await context.git.branchDelete
                  .args(branchesToDelete)
                  .askContinueQuestion(
                    "Local branches with gone remotes that would be deleted:\n${branchesToDelete.map((e) => "   • $e").join("\n")}\n",
                    assumeYes: hasForceDeleteFlag,
                    assumeNo: hasSkipDeleteFlag,
                  )
                  ?.announce('Deleting branches.')
                  .run())
              ?.printNotEmptyResultFields()
              .assertSuccessfulExitCode();
      if (result != null && needToSwitchBranches) {
        needToSwitchBranches = !branchesToDelete.contains(currentBranch);
      }
    }

    if (!hasStayOnHeadFlag &&
        (needToSwitchBranches || additionalBranches.isNotEmpty) &&
        currentBranch != null) {
      (await context.git.switch0
              .arg(currentBranch)
              .announce("Switching back to original branch '$currentBranch'.")
              .run())
          .printNotEmptyResultFields();
    }
  }
}
