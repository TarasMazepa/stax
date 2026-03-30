import 'dart:io';

import 'package:monolib_dart/json_encode_async.dart';
import 'package:stax/base/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_get_default_remote.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:monolib_dart/monolib_dart.dart';

typedef DoctorResult = ({
  bool successful,
  String name,
  String result,
  String? error,
  String? resolution,
});

class InternalCommandDoctor extends InternalCommand {
  static final flagJson = Flag(
    short: '-j',
    long: '--json',
    description: 'output in json format',
  );

  InternalCommandDoctor()
    : super(
        'doctor',
        'Helps to ensure that stax has everything to be used.',
        flags: [flagJson],
      );

  @override
  Future<void> run(final List<String> args, Context context) async {
    final isJson = flagJson.hasFlag(args);

    String boolToCheckmark(bool value) => value ? 'V' : 'X';

    final isInsideWorkTree = await context.isInsideWorkTree();

    Future<DoctorResult?> checkUserName() async {
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

      return (
        successful: hasUserName,
        name: 'git config --get user.name',
        result: userName ?? 'null',
        error: hasUserName ? null : 'Set your git user name using:',
        resolution: hasUserName
            ? null
            : 'git config --global user.name "<your preferred name>" ',
      );
    }

    Future<DoctorResult?> checkUserEmail() async {
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

      return (
        successful: hasUserEmail,
        name: 'git config --get user.email',
        result: userEmail ?? 'null',
        error: hasUserEmail ? null : 'Set your git user email using:',
        resolution: hasUserEmail
            ? null
            : 'git config --global user.email "<your preferred email>" ',
      );
    }

    Future<DoctorResult?> checkRemote() async {
      if (!isInsideWorkTree) return null;

      final remote = await context.getPreferredRemote();
      final hasRemote = remote != null;

      return (
        successful: hasRemote,
        name: 'git remote',
        result: hasRemote ? 'remote(s): $remote' : 'no remotes',
        error: hasRemote ? null : 'Set at least one remote using:',
        resolution: hasRemote
            ? null
            : 'git remote add origin <url to git repository>',
      );
    }

    Future<DoctorResult?> checkDefaultBranch() async {
      if (!isInsideWorkTree) return null;

      String? defaultBranch = await context.quietly().getDefaultBranch();
      String remote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? '<remote>';

      final hasDefaultBranch = defaultBranch != null;

      return (
        successful: hasDefaultBranch,
        name: 'git rev-parse --abbrev-ref $remote/HEAD',
        result: defaultBranch ?? 'not found',
        error: hasDefaultBranch ? null : 'Set default remote branch using:',
        resolution: hasDefaultBranch
            ? null
            : 'git fetch -p ; git remote set-head $remote -a',
      );
    }

    Future<DoctorResult?> checkGhVersion() async {
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

      final hasGh = ghVersion?.isNotEmpty == true;
      return (
        successful: hasGh,
        name: 'gh --version',
        result: ghVersion ?? 'null',
        error: hasGh ? null : '[Optional] Install GitHub CLI using:',
        resolution: hasGh ? null : 'https://github.com/cli/cli#installation',
      );
    }

    Future<DoctorResult?> checkGhAuthStatus() async {
      bool isAuthenticated = false;
      try {
        isAuthenticated =
            (await context
                    .quietly()
                    .command(['gh', 'auth', 'status'])
                    .announce('Checking if GitHub CLI is authenticated.')
                    .run())
                .isSuccess();
      } catch (e) {
        isAuthenticated = false;
      }

      return (
        successful: isAuthenticated,
        name: 'gh auth status',
        result: isAuthenticated ? 'authenticated' : 'not authenticated',
        error: isAuthenticated
            ? null
            : '[Optional] Authenticate GitHub CLI using:',
        resolution: isAuthenticated ? null : 'gh auth login',
      );
    }

    Future<DoctorResult?> checkGhRepoView() async {
      if (!isInsideWorkTree) return null;

      bool canAccessRepo = false;
      try {
        canAccessRepo =
            (await context
                    .quietly()
                    .command(['gh', 'repo', 'view'])
                    .announce('Checking if GitHub CLI can access repository.')
                    .run())
                .isSuccess();
      } catch (e) {
        canAccessRepo = false;
      }

      return (
        successful: canAccessRepo,
        name: 'gh repo view',
        result: canAccessRepo ? 'has access' : 'no access',
        error: canAccessRepo
            ? null
            : '[Optional] Ensure you have access to this repository on GitHub',
        resolution: null,
      );
    }

    final checksStream = () async* {
      for (final future in [
        checkUserName(),
        checkUserEmail(),
        checkRemote(),
        checkDefaultBranch(),
        checkGhVersion(),
        checkGhAuthStatus(),
        checkGhRepoView(),
      ]) {
        final result = await future;
        if (result != null) yield result;
      }
    }();

    if (isJson) {
      await jsonEncodeAsync({
        'checks': checksStream.map(
          (result) => {
            'successful': result.successful,
            'name': result.name,
            'result': result.result,
            'error': ?result.error,
            'resolution': ?result.resolution,
          },
        ),
      }, stdout);
      return;
    }
    await for (final result in checksStream) {
      context.printToConsole(
        '[${boolToCheckmark(result.successful)}] ${result.name} # ${result.result}',
      );
      if (result.error case final error?) {
        context.printToConsole('    X $error');
        if (result.resolution case final resolution?) {
          context.printToConsole('      $resolution');
        }
      }
    }
  }
}
