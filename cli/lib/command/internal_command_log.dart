import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

class InternalCommandLog extends InternalCommand {
  static final Flag defaultBranchFlag = Flag(
    short: '-d',
    long: '--default-branch',
    description: 'assume different default branch',
  );
  static final Flag allBranchesFlag = Flag(
    short: '-a',
    long: '--all-branches',
    description: 'show remote branches also',
  );
  static final Flag limitFlag = Flag(
    short: '-n',
    long: '--limit',
    description: 'limit amount of commits shown to the user',
  );

  InternalCommandLog()
    : super(
        'log',
        'Shows a tree of all branches.',
        flags: [defaultBranchFlag, allBranchesFlag, limitFlag],
      );

  @override
  Future<void> run(List<String> args, Context context) async {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context = context.quietly();

    final String? defaultBranch;
    final int limit;

    try {
      defaultBranch = defaultBranchFlag.getFlagValue(args);
      limit = int.tryParse(limitFlag.getFlagValue(args) ?? '100000') ?? 100000;
    } catch (e) {
      print(e);
      return;
    }

    final showAllBranches = allBranchesFlag.hasFlag(args);

    print(
      materializeDecoratedLogLines(
        root: context.gitLogAll(showAllBranches, limit),
        adapter: DecoratedLogLineProducerAdapterForGitLogAllNode(
          showAllBranches,
          defaultBranch,
        ),
      ),
    );
  }
}
