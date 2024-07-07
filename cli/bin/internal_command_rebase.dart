import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class InternalCommandRebase extends InternalCommand {
  InternalCommandRebase()
      : super(
          "rebase",
          "rebase tree of branches on top of main",
          type: InternalCommandType.hidden,
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

    if (current.line.parts.contains("HEAD")) {
      context.printToConsole("You are in detached HEAD state. Can't rebase.");
      return;
    }

    final remoteHead = current.findRemoteHead();

    if (remoteHead == null) {
      context.printToConsole("Can't find remote head.");
      return;
    }

    if (current == remoteHead) {
      context.printToConsole("Nothing to rebase.");
      return;
    }

    context.printParagraph(
        "You are about to rebase following branches on top of main");
    context.printToConsole(materializeDecoratedLogLines(
            current, DecoratedLogLineProducerAdapterForGitLogAllNode())
        .join("\n"));
  }
}
