import 'dart:io';

import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

class InternalCommandPrCreation extends InternalCommand {
  InternalCommandPrCreation()
      : super(
          'pr',
          'Creates a pull request.',
        );

  @override
  void run(final List<String> args, final Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final currentBranch = context.getCurrentBranch();
    if (currentBranch == null) {
      context.printToConsole("Can't determine current branch.");
      return;
    }

    final root = context.withSilence(true).gitLogAll().collapse();
    if (root == null) {
      context.printToConsole("Can't build branch tree.");
      return;
    }

    final current = root.findCurrent();
    if (current == null) {
      context.printToConsole("Can't find current branch in the tree.");
      return;
    }

    final targetBranch = current.parent?.line.branchNameOrCommitHash() ??
        context.getDefaultBranch();
    if (targetBranch == null) {
      context.printToConsole("Can't determine target branch.");
      return;
    }

    final remote = context.git.remote.runSync().stdout.toString().trim();
    if (remote.isEmpty) {
      context.printToConsole("Can't determine remote.");
      return;
    }

    final remoteUrl = context.git.remoteGetUrl
        .arg(remote)
        .runSync()
        .stdout
        .toString()
        .trim()
        .replaceFirstMapped(RegExp(r'git@(.*):'), (m) => 'https://${m[1]}/');

    if (remoteUrl.isEmpty) {
      context.printToConsole("Can't determine remote URL.");
      return;
    }

    final newPrUrl =
        '${remoteUrl.substring(0, remoteUrl.length - 4)}/compare/$targetBranch...$currentBranch?expand=1';

    final openCommand = () {
      if (Platform.isWindows) {
        return [
          'PowerShell',
          '-Command',
          '''& {Start-Process "$newPrUrl"}''',
        ];
      }
      return ['open', newPrUrl];
    }();

    context
        .command(openCommand)
        .announce('Opening PR creation page in browser')
        .runSync()
        .printNotEmptyResultFields();
  }
}
