import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';

import 'internal_command.dart';

class InternalCommandRebase extends InternalCommand {
  InternalCommandRebase()
      : super(
          "rebase",
          "rebase tree of branches on top of main",
          arguments: {
            "opt1":
                "Optional argument for target, will default to <remote>/HEAD",
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final root = context.withSilence(true).gitLogAll().collapse();

    if (root == null) {
      context.printToConsole("Can't find any branches.");
      return;
    }

    final current = root.findCurrent();

    if (current == null) {
      context.printToConsole("Can find current branch.");
      return;
    }

    final userProvidedTarget = args.elementAtOrNull(0);

    final GitLogAllNode? targetNode = userProvidedTarget != null
        ? root.findAnyRefThatEndsWith(userProvidedTarget)
        : root.findRemoteHead();

    if (targetNode == null) {
      context.printToConsole("Can't find target branch.");
      return;
    }

    if (current == targetNode) {
      context.printToConsole("Nothing to rebase.");
      return;
    }

    final rebaseOnto = targetNode.line.branchNameOrCommitHash();

    bool changeParentOnce = true;

    for (var node in current.localBranchNamesInOrderForRebase()) {
      final exitCode = context.git.rebase
          .args([/**/changeParentOnce ? rebaseOnto : node.parent!, node.node])
          .announce()
          .runSync()
          .printNotEmptyResultFields()
          .exitCode;
      changeParentOnce = false;
      if (exitCode != 0) {
        context.printParagraph("Rebase failed");
        return;
      }
      context.git.pushForce.announce().runSync().printNotEmptyResultFields();
    }
  }
}
