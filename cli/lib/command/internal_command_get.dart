import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

import 'internal_command.dart';

class InternalCommandGet extends InternalCommand {
  InternalCommandGet()
    : super(
        'get',
        '(Re)Checkout specified branch and all its children',
        arguments: {
          'opt1': 'Name of the remote ref. Will be matched as a suffix.',
        },
      );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    String? targetRef = args.elementAtOrNull(0);

    if (targetRef == null) {
      if (!context.commandLineContinueQuestion(
        'No target ref specified. Will use current branch.',
      )) {
        return;
      }
      targetRef = context.getCurrentBranch();

      if (targetRef == null) {
        context.printToConsole("Can't determine current branch");
        return;
      }
    }

    context.git.fetchWithPrune
        .announce('Fetching latest changes from the remote')
        .runSync()
        .printNotEmptyResultFields();

    final targetNode = context
        .withQuiet(true)
        .gitLogAll(true)
        .findAnyRefThatEndsWith(targetRef);

    if (targetNode == null) {
      context.printToConsole("Can't find target ref '$targetRef'");
      return;
    }

    for (String branch in targetNode.remoteBranchNamesInOrderForCheckout().map(
      (x) => x.substring(x.indexOf('/') + 1),
    )) {
      final exists = context.git.revParseVerify
          .arg(branch)
          .announce()
          .runSync()
          .printNotEmptyResultFields()
          .isSuccess();
      context.git.switch0
          .arg(branch)
          .announce()
          .runSync()
          .printNotEmptyResultFields();
      final success = context.git.pullForce
          .announce()
          .runSync()
          .printNotEmptyResultFields()
          .isSuccess();
      if (!success) {
        if (!exists) {
          return;
        }
        context.git.switchDetach
            .announce()
            .runSync()
            .printNotEmptyResultFields();
        context.git.branchDelete
            .arg(branch)
            .announce()
            .runSync()
            .printNotEmptyResultFields();
        context.git.switch0
            .arg(branch)
            .announce()
            .runSync()
            .printNotEmptyResultFields();
      }
    }
  }
}
