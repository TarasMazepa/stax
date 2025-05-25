import 'package:stax/context/context.dart';

extension ContextApplyBaseBranchReplacement on Context {
  String? applyBaseBranchReplacement(String? baseBranch) {
    if (baseBranch == null) return baseBranch;
    return effectiveSettings.baseBranchReplacement.getValue(baseBranch) ??
        baseBranch;
  }
}
