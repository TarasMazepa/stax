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

  String getRepositoryRoot({String? workingDirectory}) {
    return git.revParseShowTopLevel
        .announce("Getting top level location of repository.")
        .runSync(workingDirectory: workingDirectory)
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim();
  }
}
