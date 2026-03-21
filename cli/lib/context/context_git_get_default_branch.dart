import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_remote_and_branch.dart';
import 'package:stax/once.dart';

extension ContextGitGetDefaultBranch on Context {
  String? getConfiguredDefaultBranch() {
    final override = effectiveSettings.defaultBranch.value;
    if (override.isNotEmpty) return override;
    return null;
  }

  String? getDefaultBranch() {
    final configured = getConfiguredDefaultBranch();
    if (configured != null) return configured;

    final defaultRemoteAndBranch = getDefaultRemoteAndBranch();
    if (defaultRemoteAndBranch != null) {
      final defaultBranch = defaultRemoteAndBranch.branch;
      return defaultBranch == 'HEAD' ? null : defaultBranch;
    }

    final complainAboutEmptyOnce = Once();
    complainAboutEmptyOnce.wrap(() {
      final hasRemotes =
          quietly().git.remote
              .runSyncCatching()
              ?.stdout
              .toString()
              .trim()
              .isNotEmpty ??
          false;
      if (!hasRemotes) {
        printToConsole("You have no remotes. Can't figure out default branch.");
      } else {
        printToConsole(
          "None of your remotes have '<remote>/HEAD' ref locally. Try adding one manually. Couldn't figure out default branch.",
        );
      }
    })();

    return null;
  }
}
