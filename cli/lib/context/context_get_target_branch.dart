import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';

extension ContextGetTargetBranch on Context {
  String? getTargetBranch(String? parentBranch) {
    final defaultBranch = getDefaultBranch();

    if (parentBranch != null) {
      return effectiveSettings.baseBranchReplacement.getValue(parentBranch) ??
          parentBranch;
    } else {
      return effectiveSettings.baseBranchReplacement.getValue(
            defaultBranch ?? '',
          ) ??
          defaultBranch;
    }
  }
}
