import 'package:stax/command/flag.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

import 'internal_command.dart';

class InternalCommandLog extends InternalCommand {
  static final Flag defaultBranchFlag = Flag(
    long: "--default-branch",
    description: "assume different default branch",
  );
  static final Flag allBranchesFlag = Flag(
    short: "-a",
    description: "show remote branches also",
  );

  InternalCommandLog()
      : super(
          "log",
          "Builds a tree of all branches.",
          flags: [
            defaultBranchFlag,
            allBranchesFlag,
          ],
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context = context.withSilence(true);

    final defaultBranch =
        args.elementAtOrNull(args.indexOf(defaultBranchFlag.long!) + 1);

    final showAllBranches = args.remove(allBranchesFlag.short);

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
