import 'dart:io';

import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/sanitize_branch_name.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_cleanup_flags.dart';
import 'package:stax/context/context_explain_to_user_no_staged_changes.dart';
import 'package:stax/context/context_git_are_there_staged_changes.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_handle_add_all_flag.dart';

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
    if (!acceptBranchName && originalBranchName != resultingBranchName) {
      if (!context.commandLineContinueQuestion(
        "Branch name was sanitized to '$resultingBranchName'.",
      )) return;
    }
    context.printToConsole("Commit  message: '$commitMessage'");
    context.printToConsole("New branch name: '$resultingBranchName'");
    final previousBranch = createPr ? context.getCurrentBranch() : null;
    final newBranchCheckoutExitCode = context.git.checkoutNewBranch
        .arg(resultingBranchName)
        .announce('Creating new branch.')
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (newBranchCheckoutExitCode != 0) {
      context.printParagraph(
        "Looks like we can't create new branch with '$resultingBranchName' name. Please pick a different name.",
      );
      return;
    }

    String? prUrl;
    if (createPr) {
      final remote =
          context.git.remote.runSync().stdout.toString().split('\n')[0].trim();
      final remoteUrl = context.git.remoteGetUrl
          .arg(remote)
          .runSync()
          .stdout
          .toString()
          .trim()
          .replaceFirstMapped(RegExp(r'git@(.*):'), (m) => 'https://${m[1]}/');
      prUrl =
          '${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$previousBranch...$resultingBranchName?expand=1';
    }

    final commitExitCode = context.git.commitWithMessage
        .arg(commitMessage)
        .announce('Committing')
        .runSync()
        .printNotEmptyResultFields()
        .exitCode;
    if (commitExitCode != 0) {
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
      final openCommand = () {
        if (Platform.isWindows) {
          return [
            'PowerShell',
            '-Command',
            '''& {Start-Process "$prUrl"}''',
          ];
        }
        return ['open', prUrl!];
      }();

      context
          .command(openCommand)
          .announce('Opening PR in browser window')
          .runSync()
          .printNotEmptyResultFields();
    }
  }
}
