import 'dart:convert';
import 'package:stax/command/flag.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_default_branch.dart';
import 'package:stax/context/context_git_get_default_remote.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/string_empty_to_null.dart';

extension type DoctorCheckResult(
  ({
    String name,
    bool success,
    String? output,
    List<String>? errorRecommendations,
  })
  record
) {
  String get name => record.name;
  bool get success => record.success;
  String? get output => record.output;
  List<String>? get errorRecommendations => record.errorRecommendations;

  Map<String, dynamic> toJson() => {
    'name': name,
    'success': success,
    'output': output,
    if (errorRecommendations != null)
      'recommendation': errorRecommendations!.join('\n'),
  };
}

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

  Stream<DoctorCheckResult> _runChecks(Context context) async* {
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
    yield DoctorCheckResult((
      name: 'git config --get user.name',
      success: hasUserName,
      output: userName,
      errorRecommendations: hasUserName
          ? null
          : [
              'Set your git user name using:',
              '  git config --global user.name "<your preferred name>"',
            ],
    ));

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
    yield DoctorCheckResult((
      name: 'git config --get user.email',
      success: hasUserEmail,
      output: userEmail,
      errorRecommendations: hasUserEmail
          ? null
          : [
              'Set your git user email using:',
              '  git config --global user.email "<your preferred email>"',
            ],
    ));

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
    yield DoctorCheckResult((
      name: 'git config --get push.autoSetupRemote',
      success: hasAutoSetupRemote,
      output: autoSetupRemote,
      errorRecommendations: hasAutoSetupRemote
          ? null
          : [
              'Set git push.autoSetupRemote using:',
              '  git config --global push.autoSetupRemote true',
            ],
    ));

    if (context.isInsideWorkTree()) {
      final remote = context.getPreferredRemote();
      final hasRemote = remote != null;
      yield DoctorCheckResult((
        name: 'git remote',
        success: hasRemote,
        output: hasRemote ? 'remote(s): $remote' : 'no remotes',
        errorRecommendations: hasRemote
            ? null
            : [
                'Set at least one remote using:',
                '  git remote add origin <url to git repository>',
              ],
      ));

      String? defaultBranch = context.withQuiet(true).getDefaultBranch();
      String defaultRemote =
          ContextGitGetDefaultBranch.remotes?.firstOrNull ?? '<remote>';
      yield DoctorCheckResult((
        name: 'git rev-parse --abbrev-ref $defaultRemote/HEAD',
        success: defaultBranch != null,
        output: defaultBranch ?? 'not found',
        errorRecommendations: defaultBranch != null
            ? null
            : [
                'Set default remote branch using:',
                '  git fetch -p ; git remote set-head $defaultRemote -a',
              ],
      ));
    }

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
    yield DoctorCheckResult((
      name: 'gh --version',
      success: hasGhVersion,
      output: ghVersion,
      errorRecommendations: hasGhVersion
          ? null
          : [
              '[Optional] Install GitHub CLI using:',
              '  https://github.com/cli/cli#installation',
            ],
    ));

    if (hasGhVersion) {
      final isAuthenticated = context
          .withQuiet(true)
          .command(['gh', 'auth', 'status'])
          .announce('Checking if GitHub CLI is authenticated.')
          .runSync()
          .isSuccess();

      yield DoctorCheckResult((
        name: 'gh auth status',
        success: isAuthenticated,
        output: isAuthenticated ? 'authenticated' : 'not authenticated',
        errorRecommendations: isAuthenticated
            ? null
            : ['[Optional] Authenticate GitHub CLI using:', '  gh auth login'],
      ));

      if (isAuthenticated && context.isInsideWorkTree()) {
        final canAccessRepo = context
            .withQuiet(true)
            .command(['gh', 'repo', 'view'])
            .announce('Checking if GitHub CLI can access repository.')
            .runSync()
            .isSuccess();

        yield DoctorCheckResult((
          name: 'gh repo view',
          success: canAccessRepo,
          output: canAccessRepo ? 'has access' : 'no access',
          errorRecommendations: canAccessRepo
              ? null
              : ['[Optional] Ensure you have access to this repository on GitHub'],
        ));
      }
    }
  }

  @override
  Future<void> run(final List<String> args, Context context) async {
    final isJson = jsonFlag.hasFlag(args);
    String boolToCheckmark(bool value) => value ? 'V' : 'X';

    if (isJson) {
      context.printToConsole('{"checks":{');
      bool isFirst = true;
      await for (final result in _runChecks(context)) {
        if (!isFirst) {
          context.printToConsole(',');
        }
        isFirst = false;

        final item = result.toJson();
        context.printToConsole('  "${result.name}": ${jsonEncode(item)}');
      }
      context.printToConsole('}}');
    } else {
      await for (final result in _runChecks(context)) {
        context.printToConsole(
          '''[${boolToCheckmark(result.success)}] ${result.name} # ${result.output}''',
        );

        if (!result.success && result.errorRecommendations != null) {
          for (final rec in result.errorRecommendations!) {
            context.printToConsole('    X $rec');
          }
        }
      }
    }
  }
}
