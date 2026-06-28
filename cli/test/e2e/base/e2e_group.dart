import 'dart:io';

import 'package:meta/meta.dart';
import 'package:test/scaffolding.dart';

import '../../test_file_original_path.dart';
import 'is_docker_available.dart';

class E2eContainer {
  final String id;

  E2eContainer(this.id);

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
  Map<String, dynamic>? onPlatform = const {
    'windows': Skip('fails on windows'),
  },
  int? retry,
}) {
  group(
    description,
    testOn: testOn,
    timeout: timeout,
    skip: isDockerAvailable
        ? skip
        : 'Docker is not installed or daemon is not running',
    tags: tags,
    onPlatform: onPlatform,
    retry: retry,
    () {
      final uri = Uri.parse(assertTestFileUriString());
      final testFileName = uri.toFilePath();
      final repositoryRoot = uri
          .replace(path: uri.path.substring(0, uri.path.indexOf('/cli/test/')))
          .toFilePath();
      final dockerFile = testFileName.replaceRange(
        testFileName.length - 4,
        testFileName.length,
        'dockerfile',
      );
      final dockerTag = testFileName
          .replaceAll(RegExp(r'\W+'), '-')
          .replaceFirst(RegExp(r'^-+'), '')
          .toLowerCase();
      final List<E2eContainer> containerHolder = [];
      setUpAll(() async {
        await Process.run('docker', [
          'build',
          '--tag',
          'stax-e2e-test:latest',
          repositoryRoot,
        ]);
        await Process.run('docker', [
          'build',
          '--file',
          dockerFile,
          '--tag',
          dockerTag,
          '.',
        ]);
      });
      setUp(() async {
        containerHolder.add(
          E2eContainer(
            ((await Process.run('docker', [
                      'run',
                      '--rm',
                      '--detach',
                      dockerTag,
                      'sleep',
                      'infinity',
                    ])).stdout
                    as String)
                .trim(),
          ),
        );
      });
      tearDown(() async {
        await Process.run('docker', [
          'rm',
          '--force',
          containerHolder.removeLast().id,
        ]);
      });
      body(() => containerHolder.last);
    },
  );
}
