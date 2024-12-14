import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_fetch_with_prune.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/git/branch_info.dart';

class InternalCommandDeleteGoneBranches extends InternalCommand {
  static final forceDeleteFlag = Flag(
    short: '-f',
    description: 'Force delete gone branches.',
  );
  static final skipDeleteFlag = Flag(
    short: '-s',
    description: 'Skip deletion of gone branches.',
  );

  InternalCommandDeleteGoneBranches()
      : super(
          'delete-gone-branches',
          'Deletes local branches with gone remotes.',
          flags: [forceDeleteFlag, skipDeleteFlag],
        );

  @override
  void run(final List<String> args, final Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }
    context.fetchWithPrune();
    final branchesToDelete = context.git.branchVv
        .announce('Checking if any remote branches are gone.')
        .runSync()
        .printNotEmptyResultFields()
        .parseBranchInfo()
        .where((e) => e.gone)
        .map((e) => e.name)
        .toList();
    if (branchesToDelete.isEmpty) {
      context.printToConsole('No local branches with gone remotes.');
      return;
    }
    context.git.branchDelete
        .args(branchesToDelete)
        .askContinueQuestion(
          "Local branches with gone remotes that would be deleted:\n${branchesToDelete.map((e) => "   • $e").join("\n")}\n",
          assumeYes: forceDeleteFlag.hasFlag(args),
          assumeNo: skipDeleteFlag.hasFlag(args),
        )
        ?.announce('Deleting branches.')
        .runSync()
        .printNotEmptyResultFields();
  }
}
