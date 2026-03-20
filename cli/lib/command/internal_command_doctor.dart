import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_get_default_remote.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/string_empty_to_null.dart';

class InternalCommandDoctor extends InternalCommand {
  InternalCommandDoctor()
    : super(
        'doctor',
        'Helps to ensure that stax has everything to be used.',
        type: InternalCommandType.hidden,
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    String boolToCheckmark(bool value) => value ? 'V' : 'X';

    final isInsideWorkTree = context.isInsideWorkTree();

    Future<String> checkUserName() async {
      final userName =
          (await context
                  .withQuiet(true)
                  .git
                  .configGet
                  .arg('user.name')
                  .announce('Checking for users name.')
                  .run())
              .printNotEmptyResultFields()
              .stdout
              .toString()
              .trim()
              .emptyToNull();

      final hasUserName = userName != null;
      var result =
          '''[${boolToCheckmark(hasUserName)}] git config --get user.name # $userName''';

      if (!hasUserName) {
        result += '\n    X Set your git user name using:';
        result +=
            '\n      git config --global user.name "<your preferred name>" ';
      }
      return result;
    }

    Future<String> checkUserEmail() async {
      final userEmail =
          (await context
                  .withQuiet(true)
                  .git
                  .configGet
                  .arg('user.email')
                  .announce('Checking for users email.')
                  .run())
              .printNotEmptyResultFields()
              .stdout
              .toString()
              .trim()
              .emptyToNull();

      final hasUserEmail = userEmail != null;
      var result =
          '''[${boolToCheckmark(hasUserEmail)}] git config --get user.email # $userEmail''';

      if (!hasUserEmail) {
        result += '\n    X Set your git user email using:';
        result +=
            '\n      git config --global user.email "<your preferred email>" ';
      }
      return result;
    }

    Future<String> checkAutoSetupRemote() async {
      final autoSetupRemote =
          (await context
                  .withQuiet(true)
                  .git
                  .configGet
                  .arg('push.autoSetupRemote')
                  .announce(
                    'Checking if push.autoSetupRemote set in git config.',
                  )
                  .run())
              .printNotEmptyResultFields()
              .stdout
              .toString()
              .trim()
              .emptyToNull();

      final hasAutoSetupRemote = autoSetupRemote == 'true';
      var result =
          '''[${boolToCheckmark(hasAutoSetupRemote)}] git config --get push.autoSetupRemote # $hasAutoSetupRemote''';

      if (!hasAutoSetupRemote) {
        result += '\n    X Set git push.autoSetupRemote using:';
        result += '\n      git config --global push.autoSetupRemote true ';
      }
      return result;
    }

    Future<String?> checkRemote() async {
      if (!isInsideWorkTree) return null;

      final remote = context.getPreferredRemote();
      final hasRemote = remote != null;
      var result =
          """[${boolToCheckmark(hasRemote)}] git remote # ${hasRemote ? "remote(s): $remote" : "no remotes"}""";

      if (!hasRemote) {
        result += '\n    X Set at least one remote using:';
        result += '\n      git remote add origin <url to git repository>';
      }
      return result;
    }

    Future<String?> checkDefaultBranch() async {
      if (!isInsideWorkTree) return null;

      String? defaultBranch = context.withQuiet(true).getDefaultBranch();
      String remote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? '<remote>';
      var result =
          """[${boolToCheckmark(defaultBranch != null)}] git rev-parse --abbrev-ref $remote/HEAD # ${defaultBranch ?? "not found"}""";

      if (defaultBranch == null) {
        result += '\n    X Set default remote branch using:';
        result += '\n      git fetch -p ; git remote set-head $remote -a';
      }
      return result;
    }

    Future<String> checkGh() async {
      String? ghVersion;
      try {
        ghVersion =
            (await context
                    .withQuiet(true)
                    .command(['gh', '--version'])
                    .announce('Checking if GitHub CLI is installed.')
                    .run())
                .stdout
                .toString();
      } catch (e) {
        ghVersion = null;
      }

      var result =
          '''[${boolToCheckmark(ghVersion?.isNotEmpty == true)}] gh --version # $ghVersion''';

      if (ghVersion?.isNotEmpty != true) {
        result += '\n    X [Optional] Install GitHub CLI using:';
        result += '\n      https://github.com/cli/cli#installation';
        return result;
      }

      final isAuthenticated =
          (await context
                  .withQuiet(true)
                  .command(['gh', 'auth', 'status'])
                  .announce('Checking if GitHub CLI is authenticated.')
                  .run())
              .isSuccess();

      result +=
          '''\n[${boolToCheckmark(isAuthenticated)}] gh auth status # ${isAuthenticated ? "authenticated" : "not authenticated"}''';

      if (!isAuthenticated) {
        result += '\n    X [Optional] Authenticate GitHub CLI using:';
        result += '\n      gh auth login';
        return result;
      }

      if (isInsideWorkTree) {
        final canAccessRepo =
            (await context
                    .withQuiet(true)
                    .command(['gh', 'repo', 'view'])
                    .announce('Checking if GitHub CLI can access repository.')
                    .run())
                .isSuccess();

        result +=
            '''\n[${boolToCheckmark(canAccessRepo)}] gh repo view # ${canAccessRepo ? "has access" : "no access"}''';

        if (!canAccessRepo) {
          result +=
              '\n    X [Optional] Ensure you have access to this repository on GitHub';
        }
      }

      return result;
    }

    final futures = <Future<String?>>[
      checkUserName(),
      checkUserEmail(),
      checkAutoSetupRemote(),
      checkRemote(),
      checkDefaultBranch(),
      checkGh(),
    ];

    final results = await Future.wait(futures);

    for (final result in results) {
      if (result != null) {
        context.printToConsole(result);
      }
    }
  }
}
