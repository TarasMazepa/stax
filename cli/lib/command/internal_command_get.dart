import 'package:stax/base/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/internal_command_rebase.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_assert_no_conflicting_flags.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

class InternalCommandGet extends InternalCommand {
  static final currentFlag = Flag(
    short: '-c',
    long: '--current',
    description: 'Force get current branch, skipping the confirmation prompt.',
  );
  static final rebaseFlag = Flag(
    short: '-r',
    long: '--rebase',
    description:
        "Runs 'stax rebase' afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.",
  );
  static final rebaseTheirsFlag = Flag(
    short: '-m',
    long: '--rebase-prefer-moving',
    description:
        "Runs 'stax rebase ${InternalCommandRebase.theirsFlag.long}' afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.",
  );
  static final rebaseOursFlag = Flag(
    short: '-b',
    long: '--rebase-prefer-base',
    description:
        "Runs 'stax rebase ${InternalCommandRebase.oursFlag.long}' afterwards starting from the branch which we originally requested, rebasing all the branches that depend on it.",
  );

  InternalCommandGet()
    : super(
        'get',
        '(Re)Checkout specified branch and all its children',
        arguments: {
          'opt1': 'Name of the remote ref. Will be matched as a suffix.',
        },
        flags: [currentFlag, rebaseFlag, rebaseOursFlag, rebaseTheirsFlag],
      );

  @override
  Future<void> run(List<String> args, Context context) async {
    if (await context.handleNotInsideGitWorkingTree()) {
      return;
    }

    bool hasCurrentFlag = currentFlag.hasFlag(args);
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

    String? targetRef = args.elementAtOrNull(0);

    if (targetRef == null) {
      if (hasCurrentFlag) {
        targetRef = await context.getCurrentBranch();
      } else {
        if (!context.commandLineContinueQuestion(
          'No target ref specified. Will use current branch.',
        )) {
          return;
        }
        targetRef = await context.getCurrentBranch();
      }

      if (targetRef == null) {
        context.printToConsole("Can't determine current branch");
        return;
      }
    }

    final defaultBranch = await context.getDefaultBranch();
    if (defaultBranch != null) {
      (await context.git.switch0
              .arg(defaultBranch)
              .announce("Switching to default branch '$defaultBranch'.")
              .run())
          .printNotEmptyResultFields();
    }

    (await context.git.pullPrune
            .announce('Pulling new changes.')
            .run(onDemandPrint: true))
        .printNotEmptyResultFields();

    final targetNode = (await context.quietly().gitLogAll(
      true,
    )).findAnyRemoteRefThatEndsWith(targetRef);

    if (targetNode == null) {
      context.printToConsole("Can't find target ref '$targetRef'");
      return;
    }

    final branches = targetNode
        .remoteBranchNamesInOrderForCheckout()
        .map((x) => x.substring(x.indexOf('/') + 1))
        .toList();

    if (branches.isNotEmpty) {
      (await context.git.switchDetach.announce().runCatching())
          ?.printNotEmptyResultFields();
      (await context.git.branchDelete.args(branches).announce().runCatching())
          ?.printNotEmptyResultFields();
    }

    for (String branch in branches) {
      (await context.git.switch0.arg(branch).announce().runCatching())
          ?.printNotEmptyResultFields();
    }

    final shouldDoRebase =
        hasRebaseFlag || hasRebaseTheirsFlag || hasRebaseOursFlag;
    if (shouldDoRebase) {
      final originalBranch = targetNode.line.branchNameOrCommitHash();
      (await context.git.switch0.arg(originalBranch).announce().run())
          .printNotEmptyResultFields();

      final rebaseUseCase = context.assertRebaseUseCase;
      await rebaseUseCase.initiate(
        hasRebaseTheirsFlag,
        hasRebaseOursFlag,
        null,
      );
      await rebaseUseCase.continueRebase();
    }
  }
}
