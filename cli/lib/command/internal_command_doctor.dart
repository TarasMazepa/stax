import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_get_default_remote.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/string_empty_to_null.dart';

class InternalCommandDoctor extends InternalCommand {
  InternalCommandDoctor()
      : super('doctor', 'Helps to ensure that stax has everything to be used.');

  @override
  void run(final List<String> args, Context context) {
    String boolToCheckmark(bool value) => value ? 'V' : 'X';

    {
      final userName = context
          .withSilence(true)
          .git
          .configGet
          .arg('user.name')
          .announce('Checking for users name.')
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .emptyToNull();

      final hasUserName = userName != null;
      context.printToConsole(
        '''[${boolToCheckmark(hasUserName)}] git config --get user.name # $userName''',
      );

      if (!hasUserName) {
        context.printToConsole('''    X Set your git user name using:''');
        context.printToConsole(
          '''      git config --global user.name "<your preferred name>" ''',
        );
      }
    }

    {
      final userEmail = context
          .withSilence(true)
          .git
          .configGet
          .arg('user.email')
          .announce('Checking for users email.')
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .emptyToNull();

      final hasUserEmail = userEmail != null;
      context.printToConsole(
        '''[${boolToCheckmark(hasUserEmail)}] git config --get user.email # $userEmail''',
      );

      if (!hasUserEmail) {
        context.printToConsole('''    X Set your git user email using:''');
        context.printToConsole(
          '''      git config --global user.email "<your preferred email>" ''',
        );
      }
    }

    {
      final autoSetupRemote = context
          .withSilence(true)
          .git
          .configGet
          .arg('push.autoSetupRemote')
          .announce('Checking if push.autoSetupRemote set in git config.')
          .runSync()
          .printNotEmptyResultFields()
          .stdout
          .toString()
          .trim()
          .emptyToNull();

      final hasAutoSetupRemote = autoSetupRemote == 'true';
      context.printToConsole(
        '''[${boolToCheckmark(hasAutoSetupRemote)}] git config --get push.autoSetupRemote # $hasAutoSetupRemote''',
      );

      if (!hasAutoSetupRemote) {
        context.printToConsole('''    X Set git push.autoSetupRemote using:''');
        context.printToConsole(
          '''      git config --global push.autoSetupRemote true ''',
        );
      }
    }

    if (context.isInsideWorkTree()) {
      final remote = context.getPreferredRemote();
      final hasRemote = remote != null;
      context.printToConsole(
        """[${boolToCheckmark(hasRemote)}] git remote # ${hasRemote ? "remote(s): $remote" : "no remotes"}""",
      );

      if (!hasRemote) {
        context.printToConsole('''    X Set at least one remote using:''');
        context.printToConsole(
          '''      git remote add origin <url to git repository>''',
        );
      }
    }

    if (context.isInsideWorkTree()) {
      String? defaultBranch = context.withSilence(true).getDefaultBranch();
      String remote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? '<remote>';
      context.printToConsole(
        """[${boolToCheckmark(defaultBranch != null)}] git rev-parse --abbrev-ref $remote/HEAD # ${defaultBranch ?? "not found"}""",
      );

      if (defaultBranch == null) {
        context.printToConsole('''    X Set default remote branch using:''');
        context.printToConsole(
          '''      git fetch -p ; git remote set-head $remote -a''',
        );
      }
    }

    // Check gh CLI installation and authentication
    {
      String? ghVersion;
      try {
        ghVersion = context
            .withSilence(true)
            .command(['gh', '--version'])
            .announce('Checking if GitHub CLI is installed.')
            .runSync()
            .stdout
            .toString();
      } catch (e) {
        ghVersion = null;
      }

      context.printToConsole(
        '''[${boolToCheckmark(ghVersion?.isNotEmpty == true)}] gh --version # $ghVersion''',
      );

      if (ghVersion?.isNotEmpty != true) {
        context.printToConsole('''    X Install GitHub CLI using:''');
        context.printToConsole(
          '''      https://github.com/cli/cli#installation''',
        );
        return;
      }

      final isAuthenticated = context
          .withSilence(true)
          .command(['gh', 'auth', 'status'])
          .announce('Checking if GitHub CLI is authenticated.')
          .runSync()
          .isSuccess();

      context.printToConsole(
        '''[${boolToCheckmark(isAuthenticated)}] gh auth status # ${isAuthenticated ? "authenticated" : "not authenticated"}''',
      );

      if (!isAuthenticated) {
        context.printToConsole('''    X Authenticate GitHub CLI using:''');
        context.printToConsole(
          '''      gh auth login''',
        );
        return;
      }

      if (context.isInsideWorkTree()) {
        final canAccessRepo = context
            .withSilence(true)
            .command(['gh', 'repo', 'view'])
            .announce('Checking if GitHub CLI can access repository.')
            .runSync()
            .isSuccess();

        context.printToConsole(
          '''[${boolToCheckmark(canAccessRepo)}] gh repo view # ${canAccessRepo ? "has access" : "no access"}''',
        );

        if (!canAccessRepo) {
          context.printToConsole(
            '''    X Ensure you have access to this repository on GitHub''',
          );
        }
      }
    }
  }
}
