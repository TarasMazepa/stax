import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_delete.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/external_command/extended_process_result.dart';

class InternalCommandPull extends InternalCommand {
  InternalCommandPull()
    : super(
        'pull',
        'Switching to main branch, pull all the changes, deleting gone branches and switching to original branch.',
        shortName: 'p',
        arguments: {
          'opt1': 'Optional target branch, will default to <remote>/HEAD',
        },
        flags: [
          InternalCommandDelete.skipDeleteFlag,
          InternalCommandDelete.forceDeleteFlag,
        ],
      );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    final hasSkipDeleteFlag = InternalCommandDelete.skipDeleteFlag.hasFlag(
      args,
    );
    final hasForceDeleteFlag = InternalCommandDelete.forceDeleteFlag.hasFlag(
      args,
    );
    final currentBranch = context.getCurrentBranch();
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
          context.git.checkout
              .arg(defaultBranch)
              .announce("Switching to default branch '$defaultBranch'.")
              .runSync()
              .printNotEmptyResultFields()
              .assertSuccessfulExitCode();
      if (result == null) return;
    }
    result =
        context.git.pull
            .announce('Pulling new changes.')
            .runSync()
            .printNotEmptyResultFields()
            .assertSuccessfulExitCode();
    if (result == null) {
      if (needToSwitchBranches && currentBranch != null) {
        context.git.checkout
            .arg(currentBranch)
            .announce("Switching back to original branch '$currentBranch'.")
            .runSync()
            .printNotEmptyResultFields();
      }
      return;
    }

    for (final branch in additionalBranches) {
      if (branch.isNotEmpty) {
        context.git.checkout
            .arg(branch)
            .announce("Switching to additional branch '$branch'.")
            .runSync()
            .printNotEmptyResultFields();

        context.git.pull
            .announce("Pulling changes for branch '$branch'.")
            .runSync()
            .printNotEmptyResultFields();
      }
    }

    InternalCommandDelete().run([
      if (hasSkipDeleteFlag) InternalCommandDelete.skipDeleteFlag.shortOrLong,
      if (hasForceDeleteFlag) InternalCommandDelete.forceDeleteFlag.shortOrLong,
    ], context);

    if ((needToSwitchBranches || additionalBranches.isNotEmpty) &&
        currentBranch != null) {
      context.git.checkout
          .arg(currentBranch)
          .announce("Switching back to original branch '$currentBranch'.")
          .runSync()
          .printNotEmptyResultFields();
    }
  }
}
