import 'package:monolib_dart/monolib_dart.dart';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

class InternalCommandLog extends InternalCommand {
  static const int defaultLimit = 100;
  static final Flag limitFlag = Flag(
    short: '-n',
    long: '--limit',
    description: 'limit the number of commits shown (default $defaultLimit)',
  );
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

  InternalCommandLog()
    : super(
        'log',
        'Shows a tree of all branches.',
        flags: [limitFlag, defaultBranchFlag, allBranchesFlag],
      );

  @override
  Future<void> run(List<String> args, Context context) async {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context = context.quietly();

    final String? defaultBranch;

    try {
      defaultBranch = defaultBranchFlag.getFlagValue(args);
    } catch (e) {
      print(e);
      return;
    }

    final showAllBranches = allBranchesFlag.hasFlag(args);
    final limit = limitFlag.getFlagValue(args)?.let(int.parse) ?? defaultLimit;

    print(
      materializeDecoratedLogLines(
        limit: limit,
        root: context.gitLogAll(limit, showAllBranches),
        adapter: DecoratedLogLineProducerAdapterForGitLogAllNode(
          showAllBranches,
          defaultBranch,
        ),
      ),
    );
  }
}
