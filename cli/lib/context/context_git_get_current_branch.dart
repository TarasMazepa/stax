import 'package:stax/context/context.dart';
import 'package:stax/string_empty_to_null.dart';

extension ContextGitGetCurrentBranch on Context {
  static String? currentBranch;

  String? getCurrentBranch({
    String? announcement = 'Checking what is the current branch.',
  }) {
    return currentBranch ??= git.branchCurrent
        .announce(announcement)
        .runSync()
        .printNotEmptyResultFields()
        .stdout
        .toString()
        .trim()
        .emptyToNull();
  }
}
