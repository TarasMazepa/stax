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
                  .quietly()
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
      final result = StringBuffer(
        '''[${boolToCheckmark(hasUserName)}] git config --get user.name # $userName''',
      );

      if (!hasUserName) {
        result.write('\n    X Set your git user name using:');
        result.write(
          '\n      git config --global user.name "<your preferred name>" ',
        );
      }
      return result.toString();
    }

    Future<String> checkUserEmail() async {
      final userEmail =
          (await context
                  .quietly()
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
      final result = StringBuffer(
        '''[${boolToCheckmark(hasUserEmail)}] git config --get user.email # $userEmail''',
      );

      if (!hasUserEmail) {
        result.write('\n    X Set your git user email using:');
        result.write(
          '\n      git config --global user.email "<your preferred email>" ',
        );
      }
      return result.toString();
    }

    Future<String?> checkRemote() async {
      if (!isInsideWorkTree) return null;

      final remote = context.getPreferredRemote();
      final hasRemote = remote != null;
      final result = StringBuffer(
        """[${boolToCheckmark(hasRemote)}] git remote # ${hasRemote ? "remote(s): $remote" : "no remotes"}""",
      );

      if (!hasRemote) {
        result.write('\n    X Set at least one remote using:');
        result.write('\n      git remote add origin <url to git repository>');
      }
      return result.toString();
    }

    Future<String?> checkDefaultBranch() async {
      if (!isInsideWorkTree) return null;

      String? defaultBranch = context.quietly().getDefaultBranch();
      String remote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? '<remote>';
      final result = StringBuffer(
        """[${boolToCheckmark(defaultBranch != null)}] git rev-parse --abbrev-ref $remote/HEAD # ${defaultBranch ?? "not found"}""",
      );

      if (defaultBranch == null) {
        result.write('\n    X Set default remote branch using:');
        result.write('\n      git fetch -p ; git remote set-head $remote -a');
      }
      return result.toString();
    }

    Future<String> checkGh() async {
      String? ghVersion;
      try {
        ghVersion =
            (await context
                    .quietly()
                    .command(['gh', '--version'])
                    .announce('Checking if GitHub CLI is installed.')
                    .run())
                .stdout
                .toString();
      } catch (e) {
        ghVersion = null;
      }

      final result = StringBuffer(
        '''[${boolToCheckmark(ghVersion?.isNotEmpty == true)}] gh --version # $ghVersion''',
      );

      if (ghVersion?.isNotEmpty != true) {
        result.write('\n    X [Optional] Install GitHub CLI using:');
        result.write('\n      https://github.com/cli/cli#installation');
        return result.toString();
      }

      final isAuthenticated =
          (await context
                  .quietly()
                  .command(['gh', 'auth', 'status'])
                  .announce('Checking if GitHub CLI is authenticated.')
                  .run())
              .isSuccess();

      result.write(
        '''\n[${boolToCheckmark(isAuthenticated)}] gh auth status # ${isAuthenticated ? "authenticated" : "not authenticated"}''',
      );

      if (!isAuthenticated) {
        result.write('\n    X [Optional] Authenticate GitHub CLI using:');
        result.write('\n      gh auth login');
        return result.toString();
      }

      if (isInsideWorkTree) {
        final canAccessRepo =
            (await context
                    .quietly()
                    .command(['gh', 'repo', 'view'])
                    .announce('Checking if GitHub CLI can access repository.')
                    .run())
                .isSuccess();

        result.write(
          '''\n[${boolToCheckmark(canAccessRepo)}] gh repo view # ${canAccessRepo ? "has access" : "no access"}''',
        );

        if (!canAccessRepo) {
          result.write(
            '\n    X [Optional] Ensure you have access to this repository on GitHub',
          );
        }
      }

      return result.toString();
    }

    Stream<String?> streamResultsInOrder(List<Future<String?>> futures) async* {
      for (final future in futures) {
        yield await future;
      }
    }

    await for (final result in streamResultsInOrder([
      checkUserName(),
      checkUserEmail(),
      checkRemote(),
      checkDefaultBranch(),
      checkGh(),
    ])) {
      if (result != null) {
        context.printToConsole(result);
      }
    }
  }
}
