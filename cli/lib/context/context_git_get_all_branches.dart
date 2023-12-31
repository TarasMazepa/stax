import 'package:stax/context/context.dart';
import 'package:stax/git/branch_info.dart';

extension ContextGitGetAllBranches on Context {
  List<BranchInfo> getAllBranches() {
    return git.branchVv
        .announce("Getting all the branches.")
        .runSync()
        .printNotEmptyResultFields()
        .parseBranchInfo();
  }
}
