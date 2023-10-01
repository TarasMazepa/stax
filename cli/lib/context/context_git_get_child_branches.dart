import 'package:stax/context/context.dart';
import 'package:stax/git/branch_info.dart';

extension ContextGitGetChildBranches on Context {
  List<BranchInfo> getChildBranches() {
    return git.branchContains
        .announce("List child branches.")
        .runSync()
        .printNotEmptyResultFields()
        .parseBranchInfo();
  }
}
