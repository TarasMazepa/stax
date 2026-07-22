import 'dart:io';

import 'package:test/expect.dart';

import 'string_clean_carrige_return_on_windows.dart';

typedef E2eCommandRunner =
    Future<ProcessResult> Function(String command, [List<String>? args]);
const String defaultRepositoryPath = '/repo';

Future<String> _git(
  E2eCommandRunner run,
  String repository,
  List<String> args,
) async {
  final result = await run('git', ['-C', repository, ...args]);
  expect(
    result.exitCode,
    0,
    reason: 'git ${args.join(' ')} in $repository failed: ${result.stderr}',
  );
  return (result.stdout as String).cleanCarriageReturnOnWindows().trim();
}

Future<String> repositoryHistory(
  E2eCommandRunner run, {
  String repository = defaultRepositoryPath,
  List<String> revisions = const [],
  bool includeRefs = true,
}) {
  return _git(run, repository, [
    'log',
    '--pretty=format:${includeRefs ? '%T %D %s' : '%T %s'}',
    ...revisions,
  ]);
}

Future<void> expectSameRepositoryHistory(
  E2eCommandRunner run, {
  String repository = defaultRepositoryPath,
  required String expected,
  List<String> revisions = const [],
  bool includeRefs = false,
  String? reason,
}) async {
  expect(
    await repositoryHistory(
      run,
      repository: repository,
      revisions: revisions,
      includeRefs: includeRefs,
    ),
    await repositoryHistory(
      run,
      repository: expected,
      revisions: revisions,
      includeRefs: includeRefs,
    ),
    reason: reason ?? 'history of $repository differs from $expected',
  );
}

Future<String> repositoryFileDiff(
  E2eCommandRunner run, {
  String repository = defaultRepositoryPath,
}) async {
  await _git(run, repository, ['add', '--intent-to-add', '.']);
  try {
    return await _git(run, repository, ['diff']);
  } finally {
    await _git(run, repository, ['reset']);
  }
}

Future<void> expectCleanRepositoryFiles(
  E2eCommandRunner run, {
  String repository = defaultRepositoryPath,
  String? reason,
}) async {
  expect(
    await repositoryFileDiff(run, repository: repository),
    isEmpty,
    reason: reason ?? '$repository has uncommitted or untracked changes',
  );
}

Future<void> expectSameRepositoryFiles(
  E2eCommandRunner run, {
  String repository = defaultRepositoryPath,
  required String expected,
  String? reason,
}) async {
  final result = await run('diff', [
    '--recursive',
    '--exclude',
    '.git',
    repository,
    expected,
  ]);
  expect(
    result.exitCode,
    0,
    reason:
        reason ??
        'files of $repository differ from $expected:\n${result.stdout}',
  );
}
