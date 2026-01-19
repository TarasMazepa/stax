import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_apply_base_branch_replacement.dart';
import 'package:stax/context/context_get_pull_request_url.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/context/context_open_in_browser.dart';

class InternalCommandPrCreation extends InternalCommand {
  InternalCommandPrCreation()
    : super('pull-request', 'Creates a pull request.', shortName: 'pr');

  @override
  Future<void> run(final List<String> args, final Context context) async {
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

    final baseBranch = context.applyBaseBranchReplacement(
      current.parent?.line.branchName() ?? context.getDefaultBranch(),
    );

    if (baseBranch == null) {
      context.printToConsole("Can't determine target branch.");
      return;
    }

    final prUrl = context.getPullRequestUrl(baseBranch, currentBranch);
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
