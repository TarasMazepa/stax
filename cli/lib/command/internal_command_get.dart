import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

import 'internal_command.dart';

class InternalCommandGet extends InternalCommand {
  InternalCommandGet()
      : super(
          'get',
          'checkout all child branches',
          arguments: {
            'arg1': 'name of the remote ref',
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final targetRef = args.elementAtOrNull(0);

    if (targetRef == null) {
      context.printToConsole('Please specify remote ref');
      return;
    }

    context.git.fetchWithPrune
        .announce('Fetching latest changes from the remote')
        .runSync()
        .printNotEmptyResultFields();

    final targetNode = context
        .withSilence(true)
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
      context.git.checkout
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
        context.git.checkoutDetach
            .announce()
            .runSync()
            .printNotEmptyResultFields();
        context.git.branchDelete
            .arg(branch)
            .announce()
            .runSync()
            .printNotEmptyResultFields();
        context.git.checkout
            .arg(branch)
            .announce()
            .runSync()
            .printNotEmptyResultFields();
      }
    }
  }
}
