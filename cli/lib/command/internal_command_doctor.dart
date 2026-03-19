import 'dart:convert';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_get_default_remote.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/string_empty_to_null.dart';

class InternalCommandDoctor extends InternalCommand {
  static final jsonFlag = Flag(
    short: '-j',
    long: '--json',
    description: 'Output in JSON format.',
  );

  InternalCommandDoctor()
    : super(
        'doctor',
        'Helps to ensure that stax has everything to be used.',
        type: InternalCommandType.hidden,
        flags: [jsonFlag],
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    final isJson = jsonFlag.hasFlag(args);
    final List<Map<String, dynamic>> jsonResults = [];

    String boolToCheckmark(bool value) => value ? 'V' : 'X';

    {
      final userName = context
          .withQuiet(true)
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

      if (isJson) {
        jsonResults.add({
          'name': 'git config --get user.name',
          'success': hasUserName,
          'output': userName,
          if (!hasUserName) 'recommendation': 'git config --global user.name "<your preferred name>"',
        });
      } else {
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
    }

    {
      final userEmail = context
          .withQuiet(true)
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

      if (isJson) {
        jsonResults.add({
          'name': 'git config --get user.email',
          'success': hasUserEmail,
          'output': userEmail,
          if (!hasUserEmail) 'recommendation': 'git config --global user.email "<your preferred email>"',
        });
      } else {
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
    }

    {
      final autoSetupRemote = context
          .withQuiet(true)
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

      if (isJson) {
        jsonResults.add({
          'name': 'git config --get push.autoSetupRemote',
          'success': hasAutoSetupRemote,
          'output': autoSetupRemote,
          if (!hasAutoSetupRemote) 'recommendation': 'git config --global push.autoSetupRemote true',
        });
      } else {
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
    }

    if (context.isInsideWorkTree()) {
      final remote = context.getPreferredRemote();
      final hasRemote = remote != null;

      if (isJson) {
        jsonResults.add({
          'name': 'git remote',
          'success': hasRemote,
          'output': remote,
          if (!hasRemote) 'recommendation': 'git remote add origin <url to git repository>',
        });
      } else {
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
    }

    if (context.isInsideWorkTree()) {
      String? defaultBranch = context.withQuiet(true).getDefaultBranch();
      String remote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? '<remote>';

      if (isJson) {
        jsonResults.add({
          'name': 'git rev-parse --abbrev-ref $remote/HEAD',
          'success': defaultBranch != null,
          'output': defaultBranch,
          if (defaultBranch == null) 'recommendation': 'git fetch -p ; git remote set-head $remote -a',
        });
      } else {
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
    }

    // Check gh CLI installation and authentication
    {
      String? ghVersion;
      try {
        ghVersion = context
            .withQuiet(true)
            .command(['gh', '--version'])
            .announce('Checking if GitHub CLI is installed.')
            .runSync()
            .stdout
            .toString()
            .trim()
            .emptyToNull();
      } catch (e) {
        ghVersion = null;
      }

      final hasGhVersion = ghVersion?.isNotEmpty == true;

      if (isJson) {
        jsonResults.add({
          'name': 'gh --version',
          'success': hasGhVersion,
          'output': ghVersion,
          if (!hasGhVersion) 'recommendation': 'https://github.com/cli/cli#installation',
        });
      } else {
        context.printToConsole(
          '''[${boolToCheckmark(hasGhVersion)}] gh --version # $ghVersion''',
        );

        if (!hasGhVersion) {
          context.printToConsole(
            '''    X [Optional] Install GitHub CLI using:''',
          );
          context.printToConsole(
            '''      https://github.com/cli/cli#installation''',
          );
        }
      }

      if (hasGhVersion) {
        final isAuthenticated = context
            .withQuiet(true)
            .command(['gh', 'auth', 'status'])
            .announce('Checking if GitHub CLI is authenticated.')
            .runSync()
            .isSuccess();

        if (isJson) {
          jsonResults.add({
            'name': 'gh auth status',
            'success': isAuthenticated,
            'output': isAuthenticated ? 'authenticated' : 'not authenticated',
            if (!isAuthenticated) 'recommendation': 'gh auth login',
          });
        } else {
          context.printToConsole(
            '''[${boolToCheckmark(isAuthenticated)}] gh auth status # ${isAuthenticated ? "authenticated" : "not authenticated"}''',
          );

          if (!isAuthenticated) {
            context.printToConsole(
              '''    X [Optional] Authenticate GitHub CLI using:''',
            );
            context.printToConsole('''      gh auth login''');
          }
        }

        if (isAuthenticated && context.isInsideWorkTree()) {
          final canAccessRepo = context
              .withQuiet(true)
              .command(['gh', 'repo', 'view'])
              .announce('Checking if GitHub CLI can access repository.')
              .runSync()
              .isSuccess();

          if (isJson) {
            jsonResults.add({
              'name': 'gh repo view',
              'success': canAccessRepo,
              'output': canAccessRepo ? 'has access' : 'no access',
              if (!canAccessRepo) 'recommendation': 'Ensure you have access to this repository on GitHub',
            });
          } else {
            context.printToConsole(
              '''[${boolToCheckmark(canAccessRepo)}] gh repo view # ${canAccessRepo ? "has access" : "no access"}''',
            );

            if (!canAccessRepo) {
              context.printToConsole(
                '''    X [Optional] Ensure you have access to this repository on GitHub''',
              );
            }
          }
        }
      }
    }

    if (isJson) {
      context.printToConsole(jsonEncode(jsonResults));
    }
  }
}
