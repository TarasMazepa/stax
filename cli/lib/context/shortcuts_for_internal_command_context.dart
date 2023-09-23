import 'package:stax/ahead_or_behind.dart';
import 'package:stax/context/git_shortcuts_on_context.dart';

import 'context_for_internal_command.dart';

extension ShortcutGetCurrentBranchOnContext on ContextForInternalCommand {
  String? getCurrentBranch({String? workingDirectory}) {
    return context.getCurrentBranch(workingDirectory: workingDirectory);
  }

  String? getRepositoryRoot({String? workingDirectory}) {
    return context.getRepositoryRoot(workingDirectory: workingDirectory);
  }

  AheadOrBehind? isCurrentBranchAheadOrBehind({String? workingDirectory}) {
    return context.isCurrentBranchAheadOrBehind(
        workingDirectory: workingDirectory);
  }

  bool isCurrentBranchBehind({String? workingDirectory}) {
    return context.isCurrentBranchBehind(workingDirectory: workingDirectory);
  }
}
