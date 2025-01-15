import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/sanitize_branch_name.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_cleanup_flags.dart';
import 'package:stax/context/context_explain_to_user_no_staged_changes.dart';
import 'package:stax/context/context_get_pr_url.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';
import 'package:stax/context/context_open_in_browser.dart';
import 'package:stax/settings/repository_settings.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandCommit extends InternalCommand {
  static final prFlag = Flag(
    short: '-p',
    long: '--pr',
    description:
        'Opens PR creation page on your remote. Works only if you have GitHub as your remote.',
  );
  static final branchNameFlag = Flag(
    short: '-b',
    description:
        'Accepts branch name proposed by converting commit name to branch name.',
  );

  InternalCommandCommit()
      : super(
          'commit',
          'Creates a branch, commits, and pushes it to remote. '
              'First argument is mandatory commit message. '
              'Second argument is optional branch name, if not provided '
              'branch name would be generated from commit message.',
          flags: [
            prFlag,
            branchNameFlag,
            ...ContextHandleAddAllFlag.flags,
          ],
          arguments: {
            'arg1':
                'Required commit message, usually enclosed in double quotes like this: "Sample commit message".',
            'opt2':
                'Optional branch name, if not provided commit message would be converted to branch name.',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context.handleAddAllFlag(args);
    final createPr = prFlag.hasFlag(args);
    final acceptBranchName = branchNameFlag.hasFlag(args);
    if (context.areThereNoStagedChanges()) {
      context.explainToUserNoStagedChanges();
      return;
    }
    context.cleanupFlags(args);
    if (args.isEmpty) {
      context.printToConsole(
        "You need to provide commit message. Something like this: 'stax commit \"My new commit message\"'",
      );
      return;
    }
    final commitMessage = args[0];
    final String originalBranchName;
    if (args.length == 1) {
      originalBranchName = args[0];
      context.printToConsole(
        "Second parameter wasn't provided. Will convert commit message to new branch name.",
      );
    } else {
      originalBranchName = args[1];
    }
    final resultingBranchName = sanitizeBranchName(originalBranchName);
    final repoSettings = RepositorySettings.getInstanceFromContext(context);
    final repoPrefix = repoSettings?.branchPrefix.value;
    final prefix = repoPrefix?.isNotEmpty == true
        ? repoPrefix
        : Settings.instance.branchPrefix.value;
    final prefixedBranchName = prefix! + resultingBranchName;

    if (!acceptBranchName && originalBranchName != prefixedBranchName) {
      if (!context.commandLineContinueQuestion(
        "Branch name was modified to '$prefixedBranchName'.",
      )) {
        return;
      }
    }
    context.printToConsole("Commit  message: '$commitMessage'");
    context.printToConsole("New branch name: '$prefixedBranchName'");
    final previousBranch = createPr ? context.getCurrentBranch() : null;
    final newBranchCheckoutExitCode = context.git.checkoutNewBranch
        .arg(prefixedBranchName)
        .announce('Creating new branch.')
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (newBranchCheckoutExitCode != 0) {
      context.printParagraph(
        "Looks like we can't create new branch with '$prefixedBranchName' name. Please pick a different name.",
      );
      return;
    }

    String? prUrl;
    if (createPr) {
      prUrl = context.getPrUrl(previousBranch!, prefixedBranchName);
    }

    final commitExitCode = context.git.commitWithMessage
        .arg(commitMessage)
        .announce('Committing')
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (commitExitCode != 0) {
      if (previousBranch != null) {
        context.git.checkout
            .arg(previousBranch)
            .announce('Switching back to original branch')
            .runSync()
            .printNotEmptyResultFields();
      }

      context.git.branchDelete
          .arg(prefixedBranchName)
          .announce('Deleting created branch')
          .runSync()
          .printNotEmptyResultFields();

      context.printParagraph(
        'See above git error. Additionally you can check `stax doctor` command output.${prUrl != null ? '\nPR URL would have been: $prUrl' : ''}',
      );
      return;
    }

    final pushExitCode = context.git.push
        .announce('Pushing')
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (pushExitCode != 0) {
      context.printParagraph(
        'See above git error. Additionally you can check `stax doctor` command output.${prUrl != null ? '\nPR URL would have been: $prUrl' : ''}',
      );
      return;
    }

    if (prUrl != null) {
      context
          .openInBrowser(prUrl)
          .announce('Opening PR in browser window')
          .runSync()
          .printNotEmptyResultFields();
    }
  }
}
