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

  InternalCommandRebase()
    : super(
        'rebase',
        'rebase tree of branches on top of main',
        arguments: {
          'opt1': 'Optional argument for target, will default to <remote>/HEAD',
        },
        flags: [theirsFlag, oursFlag],
      );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final hasTheirsFlag = theirsFlag.hasFlag(args);
    final hasOursFlag = oursFlag.hasFlag(args);

    if (context.assertNoConflictingFlags(
      [hasTheirsFlag, hasOursFlag],
      [theirsFlag, oursFlag],
    )) {
      return;
    }

    context.assertRebaseUseCase.initiate(
      hasTheirsFlag,
      hasOursFlag,
      args.elementAtOrNull(0),
    );

    bool changeParentOnce = true;

    for (var node in context.assertRebaseUseCase.assertRebaseData.steps) {
      final exitCode =
          context.git.rebase
              .args([
                if (context
                    .assertRebaseUseCase
                    .assertRebaseData
                    .hasTheirsFlag) ...[
                  '-X',
                  'theirs',
                ],
                if (context
                    .assertRebaseUseCase
                    .assertRebaseData
                    .hasOursFlag) ...[
                  '-X',
                  'ours',
                ],
                if (changeParentOnce)
                  context.assertRebaseUseCase.assertRebaseData.rebaseOnto
                else
                  node.parent!,
                node.node,
              ])
              .announce()
              .runSync()
              .printNotEmptyResultFields()
              .exitCode;
      changeParentOnce = false;
      if (exitCode != 0) {
        context.printParagraph('Rebase failed');
        return;
      }
      context.git.pushForce.announce().runSync().printNotEmptyResultFields();
    }
  }
}
