import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_log_one_line_no_decorate_single_branch.dart';

extension ContextGitIsBranchPointingAtCommit on Context {
  bool isBranchPointingAtCommit(String branchName, String commitMessage) {
    final commits = logOneLineNoDecorateSingleBranch(branchName);
    return commits.isNotEmpty && commits.first.message == commitMessage;
  }
}
