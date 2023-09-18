import 'external_command.dart';

class Git {
  late final branch = ExternalCommand.split("git branch");
  late final branchCurrent = branch.withArgument("--show-current");
  late final branchDelete = branch.withArgument("-D");
  late final branchVv = branch.withArgument("-vv");
  late final checkout = ExternalCommand.split("git checkout");
  late final checkoutNewBranch = checkout.withArgument("-b");
  late final commit = ExternalCommand.split("git commit");
  late final commitWithMessage = commit.withArgument("-m");
  late final diff = ExternalCommand.split("git diff");
  late final diffCachedQuiet = diff.withArguments(["--cached", "--quiet"]);
  late final fetch = ExternalCommand.split("git fetch");
  late final fetchWithPrune = fetch.withArgument("-p");
  late final pull = ExternalCommand.split("git pull");
  late final push = ExternalCommand.split("git push");
  late final revList = ExternalCommand.split("git rev-list");
  late final revListCount = revList.withArgument("--count");
  late final remote = ExternalCommand.split("git remote");
  late final revParse = ExternalCommand.split("git rev-parse");
  late final revParseAbbrevRef = revParse.withArgument("--abbrev-ref");
}
