import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_assert_no_conflicting_flags.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

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
            'opt1':
                'Optional argument for target, will default to <remote>/HEAD',
          },
          flags: [
            theirsFlag,
            oursFlag,
          ],
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

    final root = context.gitLogAll();

    final current = root.findCurrent();

    if (current == null) {
      context.printToConsole('Can find current branch.');
      return;
    }

    final userProvidedTarget = args.elementAtOrNull(0);

    final GitLogAllNode? targetNode = userProvidedTarget != null
        ? root.findAnyRefThatEndsWith(userProvidedTarget)
        : root.findRemoteHead();

    if (targetNode == null) {
      context.printToConsole("Can't find target branch.");
      return;
    }

    if (current == targetNode) {
      context.printToConsole('Nothing to rebase.');
      return;
    }

    final rebaseOnto = targetNode.line.branchNameOrCommitHash();

    bool changeParentOnce = true;

    for (var node in current.localBranchNamesInOrderForRebase()) {
      final exitCode = context.git.rebase
          .args([
            if (hasTheirsFlag) ...['-X', 'theirs'],
            if (hasOursFlag) ...['-X', 'ours'],
            if (changeParentOnce) rebaseOnto else node.parent!,
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
