import 'package:stax/context/context.dart';
import 'package:stax/string_empty_to_null.dart';

extension ContextGitGetCurrentBranch on Context {
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
