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
          flags: [
            ...ContextHandleAddAllFlag.flags,
            rebaseFlag,
            rebaseOursFlag,
            rebaseTheirsFlag,
          ],
        );

  @override
  void run(final List<String> args, final Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context.handleAddAllFlag(args);
    if (context.areThereNoStagedChanges()) {
      context.explainToUserNoStagedChanges();
      return;
    }

    final hasRebaseFlag = rebaseFlag.hasFlag(args);
    final hasRebaseTheirsFlag = rebaseTheirsFlag.hasFlag(args);
    final hasRebaseOursFlag = rebaseOursFlag.hasFlag(args);

    if (context.assertNoConflictingFlags(
      [hasRebaseFlag, hasRebaseTheirsFlag, hasRebaseOursFlag],
      [rebaseFlag, rebaseTheirsFlag, rebaseOursFlag],
    )) return;

    context.git.commitAmendNoEdit
        .announce('Amending changes to a commit.')
        .runSync()
        .printNotEmptyResultFields();
    context.git.pushForce
        .announce('Force pushing to a remote.')
        .runSync()
        .printNotEmptyResultFields();

    if (hasRebaseFlag || hasRebaseTheirsFlag || hasRebaseOursFlag) {
      InternalCommandRebase().run(
        [
          if (hasRebaseTheirsFlag) InternalCommandRebase.theirsFlag.long!,
          if (hasRebaseOursFlag) InternalCommandRebase.oursFlag.long!,
          context.gitLogAll().findCurrent()!.line.branchNameOrCommitHash(),
        ],
        context,
      );
    }
  }
}
