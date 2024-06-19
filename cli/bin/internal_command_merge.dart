import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_current_branch.dart';
import 'internal_command.dart';

class InternalCommandMerge extends InternalCommand {
  InternalCommandMerge()
      : super("merge", "Merge all commits into a single one.");

  String? getHeadBranchName(String s) {
    final headBranchRegex = RegExp(r'HEAD branch: (\S+)');

    final match = headBranchRegex.firstMatch(s);

    if (match != null) {
      return match.group(1);
    } else {
      return null;
    }
  }

  @override
  void run(final List<String> args, Context context) {
    String? headBranch = getHeadBranchName(
        context.git.remoteShowOrigin.runSync().stdout.toString());
    if (headBranch == null) return;

    String? currentBranch = context.getCurrentBranch();
    String staxTmpBranch = "stax-temp-branch";

    List<String> currentBranchCommits = context.git.cherry
        .args(["-v", "master"])
        .runSync()
        .stdout
        .toString()
        .split("\n");
    if (currentBranchCommits.length <= 1) {
      return context.printToConsole("Not enough commits to merge together.");
    }
    if (currentBranch == null) return;

    String parentsLastCommitHash = "";
    String initialCommitHash = currentBranchCommits[0].split(" ")[1];
    String initialCommitMessage = currentBranchCommits[0].split(" ")[2];

    bool shouldContinue = context.commandLineContinueQuestion(
        "Stax detected $initialCommitHash $initialCommitMessage as the initial commit in this branch & will perform a merge (with squash), do you want to continue?");

    if (!shouldContinue) return;

    print(initialCommitHash);
    print(initialCommitMessage);

    context.git.checkoutNewBranch.arg(staxTmpBranch).runSync();
    if (context.getCurrentBranch() != staxTmpBranch) {
      return context.printToConsole("Branch checkout failed, exiting program.");
    }
    print("run here");
    context.git.reset.arg(initialCommitHash).announce("reseting").runSync();

    context.git.stash.announce("statsh").runSync();

    context.git.merge
        .args(["--squash", currentBranch])
        .announce("squash")
        .runSync();
    context.git.commitWithMessage
        .arg('"squashed changes"')
        .announce("commit")
        .runSync();
    context.git.checkout
        .arg(currentBranch)
        .announce("checkout current branch")
        .runSync();
    context.git.reset
        .args(["--hard", staxTmpBranch])
        .announce("reset hard tmp")
        .runSync();
    context.git.branchDelete
        .arg(staxTmpBranch)
        .announce("remove tmp branch")
        .runSync();
  }
}
