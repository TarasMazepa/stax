import 'package:stax/context/context.dart';

enum AheadOrBehind { ahead, behind, aheadAndBehind, none }

extension ContextHitIsCurrentBranchAheadOrBehind on Context {
  AheadOrBehind? isCurrentBranchAheadOrBehind() {
    final statusSb = git.statusSb
        .announce('Checking if current branch is behind remote.')
        .runSync()
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString();
    if (statusSb == null) return null;
    List<String> makeTokens(String x) => [' [$x ', ' , $x '];
    final containsAhead = makeTokens('ahead').any((e) => statusSb.contains(e));
    final containsBehind = makeTokens(
      'behind',
    ).any((e) => statusSb.contains(e));
    if (containsAhead && containsBehind) return AheadOrBehind.aheadAndBehind;
    if (containsAhead) return AheadOrBehind.ahead;
    if (containsBehind) return AheadOrBehind.behind;
    return AheadOrBehind.none;
  }

  bool isCurrentBranchBehind() {
    return isCurrentBranchAheadOrBehind() == AheadOrBehind.behind;
  }
}
