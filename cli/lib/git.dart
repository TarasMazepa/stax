import 'external_command.dart';

class Git {
  late final branch = ExternalCommand.raw("git branch");
  late final branchCurrent = branch.arg("--show-current");
  late final branchDelete = branch.arg("-D");
  late final branchVv = branch.arg("-vv");
  late final checkout = ExternalCommand.raw("git checkout");
  late final checkoutNewBranch = checkout.arg("-b");
  late final commit = ExternalCommand.raw("git commit");
  late final commitWithMessage = commit.arg("-m");
  late final diff = ExternalCommand.raw("git diff");
  late final diffCachedQuiet = diff.args(["--cached", "--quiet"]);
  late final fetch = ExternalCommand.raw("git fetch");
  late final fetchWithPrune = fetch.arg("-p");
  late final pull = ExternalCommand.raw("git pull");
  late final push = ExternalCommand.raw("git push");
  late final revList = ExternalCommand.raw("git rev-list");
  late final revListCount = revList.arg("--count");
  late final remote = ExternalCommand.raw("git remote");
  late final revParse = ExternalCommand.raw("git rev-parse");
  late final revParseAbbrevRef = revParse.arg("--abbrev-ref");
}
