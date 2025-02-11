import 'package:stax/context/context.dart';
import 'package:stax/external_command/external_command.dart';

class Git {
  late final add = rawEc('git add');
  late final addAll = add.arg('.');
  late final addEverything = add.arg('-A');
  late final addUpdate = add.args(['-u']);
  late final branch = rawEc('git branch');
  late final branchCurrent = branch.arg('--show-current');
  late final branchDelete = branch.arg('-D');
  late final branchVv = branch.arg('-vv');
  late final branchRemoteContainsHead =
      branch.args(['-r', '--contains', 'HEAD']);
  late final checkout = rawEc('git checkout');
  late final checkoutDetach = checkout.arg('--detach');
  late final checkoutNewBranch = checkout.arg('-b');
  late final clone = rawEc('git clone');
  late final commit = rawEc('git commit');
  late final commitAmendNoEdit = commit.args(['--amend', '--no-edit']);
  late final commitWithMessage = commit.arg('-m');
  late final config = rawEc('git config');
  late final configGet = config.args(['--get']);
  late final diff = rawEc('git diff');
  late final diffCachedQuiet = diff.args(['--cached', '--quiet']);
  late final fetch = rawEc('git fetch');
  late final fetchWithPrune = fetch.arg('-p');
  late final log = rawEc('git log');
  late final logOneLineNoDecorate = log.args(['--oneline', '--no-decorate']);
  late final logTimestampOne = log.args(['--format=format:%ct', '-1']);
  late final mergeBase = rawEc('git merge-base');
  late final pull = rawEc('git pull');
  late final pullForce = pull.arg('--force');
  late final push = rawEc('git push');
  late final pushForce = push.arg('--force');
  late final rebase = rawEc('git rebase');
  late final remote = rawEc('git remote');
  late final remoteGetUrl = remote.arg('get-url');
  late final revList = rawEc('git rev-list');
  late final revListCount = revList.arg('--count');
  late final revParse = rawEc('git rev-parse');
  late final revParseAbbrevRef = revParse.arg('--abbrev-ref');
  late final revParseHead = revParse.arg('HEAD');
  late final revParseIsInsideWorkTree = revParse.arg('--is-inside-work-tree');
  late final revParseShort = revParse.arg('--short');
  late final revParseShowTopLevel = revParse.arg('--show-toplevel');
  late final revParseVerify = revParse.arg('--verify');
  late final showBranch = rawEc('git show-branch');
  late final showBranchSha1Name = showBranch.arg('--sha1-name');
  late final status = rawEc('git status');
  late final statusSb = status.arg('-sb');

  final Context context;

  Git(this.context);

  ExternalCommand rawEc(String raw) {
    return ExternalCommand.raw(raw, context);
  }
}
