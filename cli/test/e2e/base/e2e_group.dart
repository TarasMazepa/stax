import 'dart:io';

import 'package:meta/meta.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:test/scaffolding.dart';

import '../../test_file_original_path.dart';

@isTestGroup
void e2eGroup(
  Object? description,
  dynamic Function(Process Function()) body, {
  String? testOn,
  Timeout? timeout,
  Object? skip,
  Object? tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  group(
    description,
    testOn: testOn,
    timeout: timeout,
    skip: skip,
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
    () {
      final testFileName = assertTestFilePath();
      final dockerFile = testFileName.replaceAll(
        RegExp(r'\.dart$'),
        '.dockerfile',
      );
      final repositoryRoot = Context.implicit()
          .withQuiet(true)
          .getRepositoryRoot()!;
      final dockerTag = testFileName
          .replaceAll(RegExp(r'\W+'), '_')
          .replaceFirst(RegExp(r'^_+'), '')
          .toLowerCase();
      Process.runSync('docker', [
        'build',
        '--tag',
        'stax-e2e-test:latest',
        repositoryRoot,
      ]);
      print('built stax-e2e-test:latest');
      Process.runSync('docker', [
        'build',
        '--file',
        dockerFile,
        '--tag',
        dockerTag,
        '.',
      ]);
      print('built $dockerTag');
      List<Process> processHolder = [];
      setUp(() async {
        processHolder.add(
          await Process.start('docker', [
            'run',
            '--rm',
            '-it',
            dockerTag,
          ], runInShell: true).then((process) {
            process.stdout.forEach((element) {
              print('stdout:${String.fromCharCodes(element)}');
            });
            process.stderr.forEach((element) {
              print('stderr:${String.fromCharCodes(element)}');
            });
            process.exitCode.then((value) {
              print('exit code:$value');
            });
            return process;
          }),
        );
        print('running $dockerTag');
      });
      tearDown(() {
        print('killing');
        processHolder.removeLast().kill();
      });
      body(() => processHolder[0]);
      test('teardown test', () {});
    },
  );
}
