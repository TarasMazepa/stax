import 'package:stax/ahead_or_behind.dart';
import 'package:stax/string_empty_to_null.dart';

import 'context_for_internal_command.dart';

extension ShortcutGetCurrentBranchOnContext on ContextForInternalCommand {
  String? getCurrentBranch({String? workingDirectory}) {
    return git.branchCurrent
        .announce("Checking what is the current branch.")
        .runSync(workingDirectory: workingDirectory)
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim()
        .emptyToNull();
  }

  String? getRepositoryRoot({String? workingDirectory}) {
    return git.revParseShowTopLevel
        .announce("Getting top level location of repository.")
        .runSync(workingDirectory: workingDirectory)
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString()
        .trim();
  }

  AheadOrBehind? isCurrentBranchAheadOrBehind({String? workingDirectory}) {
    final statusSb = git.statusSb
        .announce("Checking if current branch is behind remote.")
        .runSync(workingDirectory: workingDirectory)
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString();
    if (statusSb == null) return null;
    if (statusSb.contains(" [behind ")) return AheadOrBehind.behind;
    if (statusSb.contains(" [ahead ")) return AheadOrBehind.ahead;
    return AheadOrBehind.none;
  }

  bool isCurrentBranchBehind({String? workingDirectory}) {
    return isCurrentBranchAheadOrBehind(workingDirectory: workingDirectory) ==
        AheadOrBehind.behind;
  }
}
