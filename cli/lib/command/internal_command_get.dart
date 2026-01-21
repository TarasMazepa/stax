import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

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
  Future<void> run(List<String> args, Context context) async {
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
        .findAnyRemoteRefThatEndsWith(targetRef);

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
      final success = (await context.git.pullForce.announce().run(
        onDemandPrint: true,
      )).printNotEmptyResultFields().isSuccess();
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
