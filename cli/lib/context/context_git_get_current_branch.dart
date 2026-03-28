import 'package:stax/context/context.dart';
import 'package:monolib_dart/monolib_dart.dart';

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
