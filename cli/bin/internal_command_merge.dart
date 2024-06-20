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
        .trim()
        .split("\n");

    if (currentBranchCommits.length <= 1) {
      return context.printToConsole("Not enough commits to merge together.");
    }
    if (currentBranch == null) return;

    String parentsLastCommitHash = context.git.logOneLine
        .args(["-n", (currentBranchCommits.length + 1).toString()])
        .runSync()
        .stdout
        .toString()
        .split("\n")[currentBranchCommits.length]
        .split(" ")[0];
    String parentsLastCommitMessage = context.git.logOneLine
        .args(["-n", (currentBranchCommits.length + 1).toString()])
        .runSync()
        .stdout
        .toString()
        .split("\n")[currentBranchCommits.length]
        .split(" ")[1];

    bool shouldContinue = context.commandLineContinueQuestion(
        "Stax detected ($parentsLastCommitHash $parentsLastCommitMessage) as the last commit in this parent branch & will perform a merge (with squash), do you want to continue?");

    if (!shouldContinue) return;

    String finalCommitMessage =
        context.commandLineInputPrompt("Please enter a commit message: ");

    context.git.checkoutNewBranch.arg(staxTmpBranch).runSync();
    if (context.getCurrentBranch() != staxTmpBranch) {
      return context.printToConsole("Branch checkout failed, exiting program.");
    }

    context.git.reset.arg(parentsLastCommitHash).announce("reseting").runSync();

    context.git.stash.announce("statsh").runSync();

    context.git.merge
        .args(["--squash", currentBranch])
        .announce("squash")
        .runSync();
    context.git.commitWithMessage
        .arg(finalCommitMessage)
        .announce("commit")
        .runSync();
    context.git.checkout.arg(currentBranch).announce("checkout").runSync();
    context.git.reset
        .args(["--hard", staxTmpBranch])
        .announce("reset hard temp branch")
        .runSync();
    context.git.branchDelete
        .arg(staxTmpBranch)
        .announce("remove temp branch")
        .runSync();
  }
}
