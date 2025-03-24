import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_assert_no_conflicting_flags.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';

import 'internal_command.dart';

class InternalCommandRebase extends InternalCommand {
  static final theirsFlag = Flag(
    short: '-m',
    long: '--prefer-moving',
    description: 'Prefer moving changes on conflict.',
  );
  static final oursFlag = Flag(
    short: '-b',
    long: '--prefer-base',
    description: 'Prefer base changes on conflict.',
  );
  static final continueFlag = Flag(
    short: '-c',
    long: '--continue',
    description: 'Continue rebase that is in progress.',
  );
  static final abortFlag = Flag(
    short: '-a',
    long: '--abandon',
    description: "Abandon rebase that is in progress, stax can't abort its rebases.",
  );

  InternalCommandRebase()
    : super(
        'rebase',
        'rebase tree of branches on top of main',
        arguments: {
          'opt1': 'Optional argument for target, will default to <remote>/HEAD',
        },
        flags: [theirsFlag, oursFlag, continueFlag, abortFlag],
      );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final hasContinueFlag = continueFlag.hasFlag(args);
    final hasAbortFlag = abortFlag.hasFlag(args);

    if (context.assertNoConflictingFlags([
      if (hasContinueFlag) continueFlag,
      if (hasAbortFlag) abortFlag,
    ])) {
      return;
    }

    final hasTheirsFlag = theirsFlag.hasFlag(args);
    final hasOursFlag = oursFlag.hasFlag(args);

    if (context.assertNoConflictingFlags([
      if (hasTheirsFlag) theirsFlag,
      if (hasOursFlag) oursFlag,
    ])) {
      return;
    }

    if (context.assertNoConflictingFlags([
      if (hasContinueFlag) continueFlag,
      if (hasTheirsFlag) theirsFlag,
      if (hasOursFlag) oursFlag,
    ])) {
      return;
    }

    if (context.assertNoConflictingFlags([
      if (hasAbortFlag) abortFlag,
      if (hasTheirsFlag) theirsFlag,
      if (hasOursFlag) oursFlag,
    ])) {
      return;
    }

    if (hasContinueFlag) {
      context.assertRebaseUseCase
        ..assertRebaseInProgress()
        ..continueRebase();
      return;
    }

    if (hasAbortFlag) {
      context.assertRebaseUseCase
        ..assertRebaseInProgress()
        ..abort();
      context.printParagraph('Rebase successfully aborted.');
      return;
    }

    context.assertRebaseUseCase
      ..initiate(hasTheirsFlag, hasOursFlag, args.elementAtOrNull(0))
      ..continueRebase();
  }
}
