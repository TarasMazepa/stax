import 'package:monolib_dart/monolib_dart.dart';
import 'package:stax/context/context.dart';

extension ContextGitGetCurrentBranch on Context {
  static String? currentBranch;

  Future<String?> getCurrentBranch({
    String? announcement = 'Checking what is the current branch.',
  }) async {
    return currentBranch ??=
        (await git.branchCurrent.announce(announcement).run())
            .printNotEmptyResultFields()
            .stdout
            .toString()
            .trim()
            .emptyToNull();
  }
}
