import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

import 'internal_command.dart';

class InternalCommandCheckout extends InternalCommand {
  InternalCommandCheckout()
      : super(
          "checkout",
          "checkout PR stack",
          arguments: {
            "arg1": "name of the remote ref",
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final targetRef = args.elementAtOrNull(0);

    if (targetRef == null) {
      context.printToConsole("Please specify remote ref");
      return;
    }

    final targetNode =
        context.withSilence(true).gitLogAll().collapse(true)?.find(
              (x) => x.line.parts.any(
                (p) => p.endsWith(targetRef),
              ),
            );

    if (targetNode == null) {
      context.printToConsole("Can't find target ref '$targetRef'");
      return;
    }

    for (String branch in targetNode.remoteBranchNamesInOrderForCheckout()) {
      final result = context.git.checkout
          .arg(branch)
          .announce()
          .runSync()
          .printNotEmptyResultFields()
          .assertSuccessfulExitCode();
      if (result == null) return;
    }
  }
}
