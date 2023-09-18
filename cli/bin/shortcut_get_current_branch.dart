import 'package:stax/string_empty_to_null.dart';

import 'context_for_internal_command.dart';

extension ShortcutGetCurrentBranchOnContext on ContextForInternalCommand {
  String? getCurrentBranch() {
    return git.branchCurrent
        .announce("Checking what is the current branch.")
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim()
        .emptyToNull();
  }
}
