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
      final rebaseArgs = <String>[
        if (hasContinueFlag) InternalCommandRebase.continueFlag.shortOrLong,
        if (hasAbortFlag) InternalCommandRebase.abortFlag.shortOrLong,
      ];
      await InternalCommandRebase().run(rebaseArgs, context);
      return;
    }

    final pullArgs = <String>[
      if (InternalCommandDeleteStale.forceDeleteFlag.hasFlag(args))
        InternalCommandDeleteStale.forceDeleteFlag.shortOrLong,
      if (InternalCommandDeleteStale.skipDeleteFlag.hasFlag(args))
        InternalCommandDeleteStale.skipDeleteFlag.shortOrLong,
      InternalCommandPull.stayOnHeadFlag.shortOrLong,
    ];

    await InternalCommandPull().run(pullArgs, context);

    final targetBranch = args.where((arg) => !arg.startsWith('-')).firstOrNull;

    final getArgs = <String>[
      if (InternalCommandGet.currentFlag.hasFlag(args))
        InternalCommandGet.currentFlag.shortOrLong,
      if (InternalCommandGet.rebaseOursFlag.hasFlag(args))
        InternalCommandGet.rebaseOursFlag.shortOrLong
      else if (InternalCommandGet.rebaseTheirsFlag.hasFlag(args))
        InternalCommandGet.rebaseTheirsFlag.shortOrLong
      else
        InternalCommandGet.rebaseFlag.shortOrLong,
      if (targetBranch != null) targetBranch,
    ];

    await InternalCommandGet().run(getArgs, context);
  }
}
