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

  InternalCommandAmend()
    : super(
        'amend',
        'Amends and pushes changes.',
        shortName: 'a',
        flags: [
          ...ContextHandleAddAllFlag.flags,
          rebaseFlag,
          rebaseOursFlag,
          rebaseTheirsFlag,
        ],
      );

  @override
  Future<void> run(final List<String> args, final Context context) async {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context.handleAddAllFlag(args);

    if (context.areThereNoStagedChanges()) {
      context.explainToUserNoStagedChanges();
      return;
    }

    bool hasRebaseFlag = rebaseFlag.hasFlag(args);
    bool hasRebaseTheirsFlag = rebaseTheirsFlag.hasFlag(args);
    bool hasRebaseOursFlag = rebaseOursFlag.hasFlag(args);

    if (context.assertNoConflictingFlags([
      if (hasRebaseFlag) rebaseFlag,
      if (hasRebaseTheirsFlag) rebaseTheirsFlag,
      if (hasRebaseOursFlag) rebaseOursFlag,
    ])) {
      return;
    }

    final current = context.gitLogAll().findCurrent();

    bool hasAnyRebaseFlag() =>
        hasRebaseFlag || hasRebaseTheirsFlag || hasRebaseOursFlag;

    if (!hasAnyRebaseFlag() && current?.children.isNotEmpty == true) {
      switch (context.commandLineMultipleOptionsQuestion(
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
      )) {
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

    final rebaseUseCase = context.assertRebaseUseCase;
    final shouldDoRebase = hasAnyRebaseFlag();

    if (shouldDoRebase) {
      rebaseUseCase.initiate(
        hasRebaseTheirsFlag,
        hasRebaseOursFlag,
        current!.line.branchNameOrCommitHash(),
      );
      rebaseUseCase.assertRebaseData.index++;
      rebaseUseCase.save();
    }

    context.git.commitAmendNoEdit
        .announce('Amending changes to a commit.')
        .runSync()
        .printNotEmptyResultFields();
    context.git.pushForce
        .announce('Force pushing to a remote.')
        .runSync()
        .printNotEmptyResultFields();

    if (shouldDoRebase) {
      rebaseUseCase.continueRebase();
    }
  }
}
