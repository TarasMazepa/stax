import 'package:stax/base/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_extras.dart';
import 'package:stax/command/internal_command_finder.dart';
import 'package:stax/command/internal_command_rebase.dart';
import 'package:stax/command/internal_commands.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_assert_no_conflicting_flags.dart';
import 'package:stax/context/context_explain_to_user_no_staged_changes.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';

class InternalCommandAmend extends InternalCommand {
  static final rebaseFlag = Flag(
    short: '-r',
    long: '--rebase',
    description: "Runs 'stax rebase' afterwards on all children branches.",
  );
  static final getFirstFlag = Flag(
    short: '-g',
    long: '--get-first',
    description:
        "Runs 'git stash ; stax get --current ; git stash pop' before performing amend sequence.",
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
  static final skipRebaseFlag = Flag(
    long: '--skip-rebase',
    description: 'Skip asking for rebase entirely.',
  );

  InternalCommandAmend()
    : super(
        'amend',
        'Amends and pushes changes.',
        shortName: 'a',
        flags: [
          ...ContextHandleAddAllFlag.flags,
          getFirstFlag,
          rebaseFlag,
          rebaseOursFlag,
          rebaseTheirsFlag,
          skipRebaseFlag,
        ],
      );

  @override
  Future<void> run(final List<String> args, final Context context) async {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    bool hasGetFirstFlag = getFirstFlag.hasFlag(args);

    if (hasGetFirstFlag) {
      final hasChanges = context.git.statusPorcelainUno
          .runSync()
          .stdout
          .trim()
          .isNotEmpty;
      if (hasChanges) {
        (await context.git.stash
                .announce('Stashing changes before getting current branch.')
                .run())
            .exitCode;
      }
      await (internalCommands.findByNameOrPrefix('get') ??
              extraCommands.findByNameOrPrefix('get'))
          ?.run(['--current'], context);
      if (hasChanges) {
        final exitCode =
            (await context.git.stashPop
                    .announce(
                      'Popping stashed changes after getting current branch.',
                    )
                    .run())
                .exitCode;
        if (exitCode != 0) {
          context.printParagraph(
            'Stash pop resulted in conflicts. Please resolve them before amending.',
          );
          return;
        }
      }
    }

    await context.handleAddAllFlag(args);

    if (await context.areThereNoStagedChanges()) {
      context.explainToUserNoStagedChanges();
      return;
    }

    bool hasRebaseFlag = rebaseFlag.hasFlag(args);
    bool hasRebaseTheirsFlag = rebaseTheirsFlag.hasFlag(args);
    bool hasRebaseOursFlag = rebaseOursFlag.hasFlag(args);
    bool hasSkipRebaseFlag = skipRebaseFlag.hasFlag(args);

    if (context.assertNoConflictingFlags([
      if (hasRebaseFlag) rebaseFlag,
      if (hasRebaseTheirsFlag) rebaseTheirsFlag,
      if (hasRebaseOursFlag) rebaseOursFlag,
      if (hasSkipRebaseFlag) skipRebaseFlag,
    ])) {
      return;
    }

    final current = context.gitLogAll().findCurrent();

    bool hasAnyRebaseFlag() =>
        hasRebaseFlag || hasRebaseTheirsFlag || hasRebaseOursFlag;

    if (!hasAnyRebaseFlag() &&
        !hasSkipRebaseFlag &&
        current?.children.isNotEmpty == true) {
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

    final commitResult =
        (await context.git.commitAmendNoEdit
                .announce('Amending changes to a commit.')
                .run(onDemandPrint: true))
            .printNotEmptyResultFields()
            .assertSuccessfulExitCode();

    if (commitResult == null) {
      context.printParagraph("Can't amend, commit wasn't successful.");
      if (shouldDoRebase) {
        rebaseUseCase.abort();
      }
      return;
    }

    final pushResult = context.git.pushForce
        .announce('Force pushing to a remote.')
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode();

    if (pushResult == null) {
      context.printParagraph("Can't rebase, amend wasn't successful.");
      if (shouldDoRebase) {
        rebaseUseCase.abort();
      }
      return;
    }

    if (shouldDoRebase) {
      rebaseUseCase.continueRebase();
    }
  }
}
