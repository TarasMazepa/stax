import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command_rebase.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_assert_no_conflicting_flags.dart';
import 'package:stax/context/context_explain_to_user_no_staged_changes.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';

import 'internal_command.dart';

class InternalCommandAmend extends InternalCommand {
  static final rebaseFlag = Flag(
    short: '-r',
    long: '--rebase',
    description: "Runs 'stax rebase' afterwards on all children branches.",
  );
  static final rebaseTheirsFlag = Flag(
    short: '-m',
    long: '--rebase-prefer-moving',
    description:
        "Runs 'stax rebase ${InternalCommandRebase.theirsFlag.long}' afterwards on all children branches.",
  );
  static final rebaseOursFlag = Flag(
    short: '-b',
    long: '--rebase-prefer-base',
    description:
        "Runs 'stax rebase ${InternalCommandRebase.oursFlag.long}' afterwards on all children branches.",
  );
  static final forcePushFlag = Flag(
    short: '-f',
    long: '--force',
    description: 'Force push without asking if no changes to amend.',
  );
  static final skipPushFlag = Flag(
    short: '-s',
    long: '--skip',
    description: 'Skip force push without asking if no changes to amend.',
  );

  InternalCommandAmend()
    : super(
        'amend',
        'Amends and pushes changes.',
        flags: [
          ...ContextHandleAddAllFlag.flags,
          rebaseFlag,
          rebaseOursFlag,
          rebaseTheirsFlag,
          forcePushFlag,
          skipPushFlag,
        ],
      );

  @override
  void run(final List<String> args, final Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context.handleAddAllFlag(args);

    bool hasRebaseFlag = rebaseFlag.hasFlag(args);
    bool hasRebaseTheirsFlag = rebaseTheirsFlag.hasFlag(args);
    bool hasRebaseOursFlag = rebaseOursFlag.hasFlag(args);
    final hasForcePushFlag = forcePushFlag.hasFlag(args);
    final hasSkipPushFlag = skipPushFlag.hasFlag(args);

    if (context.assertNoConflictingFlags(
      [hasRebaseFlag, hasRebaseTheirsFlag, hasRebaseOursFlag],
      [rebaseFlag, rebaseTheirsFlag, rebaseOursFlag],
    )) {
      return;
    }

    if (context.assertNoConflictingFlags(
      [hasForcePushFlag, hasSkipPushFlag],
      [forcePushFlag, skipPushFlag],
    )) {
      return;
    }

    final hasChanges = !context.areThereNoStagedChanges();
    final current = context.gitLogAll().findCurrent();

    if (hasChanges) {
      context.git.commitAmendNoEdit
          .announce('Amending changes to a commit.')
          .runSync()
          .printNotEmptyResultFields();
      context.git.pushForce
          .announce('Force pushing to a remote.')
          .runSync()
          .printNotEmptyResultFields();
    } else {
      context.explainToUserNoStagedChanges();

      if (hasSkipPushFlag) {
        context.printToConsole('Skipping force push as requested.');
      } else if (hasForcePushFlag) {
        context.git.pushForce
            .announce('Force pushing to a remote.')
            .runSync()
            .printNotEmptyResultFields();
      } else {
        context.git.pushForce
            .askContinueQuestion('Would you like to force push anyway?')
            ?.announce('Force pushing to a remote.')
            .runSync()
            .printNotEmptyResultFields();
      }
    }

    bool hasAnyRebaseFlag() =>
        hasRebaseFlag || hasRebaseTheirsFlag || hasRebaseOursFlag;

    if (!hasAnyRebaseFlag() && current?.children.isNotEmpty == true) {
      final rebaseOption = context.commandLineMultipleOptionsQuestion(
        'This branch has children. Would you like to rebase them?',
        [
          (key: 'r', description: 'Standard rebase'),
          (
            key: 'm',
            description: 'Rebase prefer moving (--rebase-prefer-moving)',
          ),
          (key: 'b', description: 'Rebase prefer base (--rebase-prefer-base)'),
          (key: '<any>', description: 'Decline'),
        ],
      );

      switch (rebaseOption) {
        case 'r':
          hasRebaseFlag = true;
          break;
        case 'm':
          hasRebaseTheirsFlag = true;
          break;
        case 'b':
          hasRebaseOursFlag = true;
          break;
      }
    }

    if (hasAnyRebaseFlag()) {
      InternalCommandRebase().run([
        if (hasRebaseTheirsFlag) InternalCommandRebase.theirsFlag.long!,
        if (hasRebaseOursFlag) InternalCommandRebase.oursFlag.long!,
        current!.line.branchNameOrCommitHash(),
      ], context);
    }
  }
}
