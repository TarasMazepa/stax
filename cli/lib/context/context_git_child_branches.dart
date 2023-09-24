import 'package:stax/context/context.dart';
import 'package:stax/git/extract_branch_names.dart';
import 'package:stax/git/prepare_branch_names_for_extraction.dart';

extension ContextGitChildBranches on Context {
  List<String> getChildBranches() {
    return git.branchContains
        .announce("List child branches.")
        .runSync()
        .printNotEmptyResultFields()
        .prepareBranchNameForExtraction()
        .extractBranchNames()
        .toList();
  }
}
