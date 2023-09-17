import 'external_command.dart';

class Git {
  static final branch = ExternalCommand.split("git branch");
  static final branchCurrent = branch.withArgument("--show-current");
  static final branchDelete = branch.withArgument("-D");
  static final branchVv = branch.withArgument("-vv");
  static final checkout = ExternalCommand.split("git checkout");
  static final checkoutNewBranch = checkout.withArgument("-b");
  static final commit = ExternalCommand.split("git commit");
  static final commitWithMessage = commit.withArgument("-m");
  static final diff = ExternalCommand.split("git diff");
  static final diffCachedQuiet = diff.withArguments(["--cached", "--quiet"]);
  static final fetch = ExternalCommand.split("git fetch");
  static final fetchWithPrune = fetch.withArgument("-p");
  static final pull = ExternalCommand.split("git pull");
  static final push = ExternalCommand.split("git push");
}
