import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  static final String defaultBranchFlag = "--default-branch";
  static final String allBranchesFlag = "-a";

  InternalCommandLog()
      : super(
          "log",
          "Builds a tree of all branches.",
          flags: {
            defaultBranchFlag: "assume different default branch",
            allBranchesFlag: "show remote branches also"
          },
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context = context.withSilence(true);

    final defaultBranch =
        args.elementAtOrNull(args.indexOf(defaultBranchFlag) + 1);

    final showAllBranches = args.remove(allBranchesFlag);

    print(
      materializeDecoratedLogLines(
        context.gitLogAll().collapse(showAllBranches),
        DecoratedLogLineProducerAdapterForGitLogAllNode(
          showAllBranches,
          defaultBranch,
        ),
      ).join("\n"),
    );
  }
}
