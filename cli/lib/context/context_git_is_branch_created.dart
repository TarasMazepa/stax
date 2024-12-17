import 'package:stax/context/context.dart';

extension ContextGitIsBranchCreated on Context {
  bool isBranchCreated(String branchName) {
    return git.revParseVerify
        .arg(branchName)
        .announce('Checking if branch exists.')
        .runSync()
        .printNotEmptyResultFields()
        .isSuccess();
  }
}
