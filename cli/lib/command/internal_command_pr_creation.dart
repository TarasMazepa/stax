import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_get_pr_url.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/context/context_open_in_browser.dart';

class InternalCommandPrCreation extends InternalCommand {
  InternalCommandPrCreation()
      : super(
          'pull-request',
          'Creates a pull request.',
          shortName: 'pr',
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

    final root = context.gitLogAll();

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

    final prUrl = context.getPrUrl(targetBranch, currentBranch);
    if (prUrl == null) {
      context.printToConsole("Can't generate PR URL.");
      return;
    }

    context
        .openInBrowser(prUrl)
        .announce('Opening PR creation page in browser')
        .runSync()
        .printNotEmptyResultFields();
  }
}
