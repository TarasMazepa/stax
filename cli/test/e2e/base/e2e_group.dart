import 'dart:io';

import 'package:meta/meta.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_get_repository_root.dart';
import 'package:test/scaffolding.dart';

import '../../test_file_original_path.dart';

class E2eContainer {
  final String id;

  E2eContainer._(this.id);

  /// Runs [cmd] inside the container and returns stdout/stderr/exitCode.
  Future<ProcessResult> exec(List<String> cmd) {
    return Process.run('docker', ['exec', id, ...cmd]);
  }

  /// Convenience wrapper that prepends 'stax' to [args].
  Future<ProcessResult> stax(List<String> args) {
    return exec(['stax', ...args]);
  }
}

@isTestGroup
void e2eGroup(
  Object? description,
  dynamic Function(E2eContainer Function()) body, {
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
      final List<E2eContainer> containerHolder = [];
      setUp(() {
        final result = Process.runSync('docker', [
          'run',
          '--rm',
          '--detach',
          dockerTag,
          'sleep',
          'infinity',
        ]);
        final containerId = (result.stdout as String).trim();
        containerHolder.add(E2eContainer._(containerId));
        print('started container $containerId');
      });
      tearDown(() {
        final container = containerHolder.removeLast();
        Process.runSync('docker', ['rm', '--force', container.id]);
        print('removed container ${container.id}');
      });
      body(() => containerHolder.last);
      test('teardown test', () {});
    },
  );
}
