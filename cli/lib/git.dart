import 'external_command.dart';

class Git {
  late final branch = rawEc("git branch");
  late final branchCurrent = branch.arg("--show-current");
  late final branchDelete = branch.arg("-D");
  late final branchVv = branch.arg("-vv");
  late final checkout = rawEc("git checkout");
  late final checkoutNewBranch = checkout.arg("-b");
  late final commit = rawEc("git commit");
  late final commitWithMessage = commit.arg("-m");
  late final diff = rawEc("git diff");
  late final diffCachedQuiet = diff.args(["--cached", "--quiet"]);
  late final fetch = rawEc("git fetch");
  late final fetchWithPrune = fetch.arg("-p");
  late final pull = rawEc("git pull");
  late final push = rawEc("git push");
  late final revList = rawEc("git rev-list");
  late final revListCount = revList.arg("--count");
  late final remote = rawEc("git remote");
  late final revParse = rawEc("git rev-parse");
  late final revParseAbbrevRef = revParse.arg("--abbrev-ref");

  ExternalCommand rawEc(String raw) {
    return ExternalCommand.raw(raw);
  }
}
