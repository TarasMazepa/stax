import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_delete_stale.dart';
import 'package:stax/command/internal_command_get.dart';
import 'package:stax/command/internal_command_pull.dart';
import 'package:stax/command/internal_command_rebase.dart';
import 'package:stax/context/context.dart';
import 'package:stax/command/types_for_internal_command.dart';

class InternalCommandPullGetRebase extends InternalCommand {
  static final continueFlag = Flag(
    short: '-C',
    long: '--continue',
    description: 'Continue rebase that is in progress.',
  );

  InternalCommandPullGetRebase()
    : super(
        'pull-get-rebase',
        'Pulls, gets, and rebases sequentially.',
        type: InternalCommandType.public,
        arguments: {
          'opt1':
              'Optional target branch name that stax should "get", will default to <remote>/HEAD',
        },
        flags: [
          continueFlag,
          InternalCommandRebase.abortFlag,
          InternalCommandGet.rebaseOursFlag,
          InternalCommandGet.currentFlag,
          InternalCommandDeleteStale.forceDeleteFlag,
          InternalCommandGet.rebaseTheirsFlag,
          InternalCommandPull.stayOnHeadFlag,
          InternalCommandGet.rebaseFlag,
          InternalCommandDeleteStale.skipDeleteFlag,
        ],
      );

  @override
  Future<void> run(List<String> args, Context context) async {
    final hasContinueFlag = continueFlag.hasFlag(args);
    final hasAbortFlag = InternalCommandRebase.abortFlag.hasFlag(args);

    if (hasContinueFlag || hasAbortFlag) {
      final rebaseArgs = <String>[];
      if (hasContinueFlag) {
        rebaseArgs.add(InternalCommandRebase.continueFlag.shortOrLong);
      }
      if (hasAbortFlag) {
        rebaseArgs.add(InternalCommandRebase.abortFlag.shortOrLong);
      }
      await InternalCommandRebase().run(rebaseArgs, context);
      return;
    }

    final pullArgs = <String>[];
    if (InternalCommandDeleteStale.forceDeleteFlag.hasFlag(args)) {
      pullArgs.add(InternalCommandDeleteStale.forceDeleteFlag.shortOrLong);
    }
    if (InternalCommandDeleteStale.skipDeleteFlag.hasFlag(args)) {
      pullArgs.add(InternalCommandDeleteStale.skipDeleteFlag.shortOrLong);
    }
    pullArgs.add(InternalCommandPull.stayOnHeadFlag.shortOrLong);

    await InternalCommandPull().run(pullArgs, context);

    final getArgs = <String>[];
    if (InternalCommandGet.currentFlag.hasFlag(args)) {
      getArgs.add(InternalCommandGet.currentFlag.shortOrLong);
    }
    if (InternalCommandGet.rebaseOursFlag.hasFlag(args)) {
      getArgs.add(InternalCommandGet.rebaseOursFlag.shortOrLong);
    } else if (InternalCommandGet.rebaseTheirsFlag.hasFlag(args)) {
      getArgs.add(InternalCommandGet.rebaseTheirsFlag.shortOrLong);
    } else {
      getArgs.add(InternalCommandGet.rebaseFlag.shortOrLong);
    }

    final targetBranch = args.where((arg) => !arg.startsWith('-')).firstOrNull;
    if (targetBranch != null) {
      getArgs.add(targetBranch);
    }

    await InternalCommandGet().run(getArgs, context);
  }
}
