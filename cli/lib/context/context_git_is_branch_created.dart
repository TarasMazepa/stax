import 'package:stax/context/context.dart';

extension ContextGitIsBranchCreated on Context {
  bool isBranchCreatedAndPointingAtCommit(
    String branchName,
    String commitMessage,
  ) {
    return git.branchCurrent
        .arg(branchName)
        .announce('Checking if branch exists and points at commit.')
        .runSync()
        .printNotEmptyResultFields()
        .isSuccess();
  }
}
