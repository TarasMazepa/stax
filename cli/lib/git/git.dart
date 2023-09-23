import 'package:stax/context/context.dart';

import 'package:stax/external_command.dart';

class Git {
  late final branch = rawEc("git branch");
  late final branchContains = branch.arg("--contains");
  late final branchCurrent = branch.arg("--show-current");
  late final branchDelete = branch.arg("-D");
  late final branchVv = branch.arg("-vv");
  late final checkout = rawEc("git checkout");
  late final checkoutNewBranch = checkout.arg("-b");
  late final commit = rawEc("git commit");
  late final commitWithMessage = commit.arg("-m");
  late final commitAmendNoEdit = commit.args(["--amend", "--no-edit"]);
  late final diff = rawEc("git diff");
  late final diffCachedQuiet = diff.args(["--cached", "--quiet"]);
  late final fetch = rawEc("git fetch");
  late final fetchWithPrune = fetch.arg("-p");
  late final pull = rawEc("git pull");
  late final push = rawEc("git push");
  late final pushForce = push.arg("--force");
  late final revList = rawEc("git rev-list");
  late final revListCount = revList.arg("--count");
  late final remote = rawEc("git remote");
  late final revParse = rawEc("git rev-parse");
  late final revParseAbbrevRef = revParse.arg("--abbrev-ref");
  late final revParseHead = revParse.arg("HEAD");
  late final revParseShowTopLevel = revParse.arg("--show-toplevel");
  late final status = rawEc("git status");
  late final statusSb = status.arg("-sb");

  final Context context;

  Git(this.context);

  ExternalCommand rawEc(String raw) {
    return ExternalCommand.raw(raw, context);
  }
}
