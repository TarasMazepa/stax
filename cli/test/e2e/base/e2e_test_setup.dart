import 'dart:io';

import '../../test_file_original_path.dart';

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

/// Builds the base `stax-e2e-test:latest` image at most once per test run.
///
/// The image is identical for every test group, so caching the build [Future]
/// at the top level avoids rebuilding it once per group. A fresh `dart test`
/// run starts a new process where this is null again, so rebuilds still happen
/// between separate runs.
Future<void>? _baseDockerBuildFuture;

class E2eTestSetup {
  final String repositoryRoot;
  final String dockerFile;
  final String dockerTag;
  final List<E2eContainer> _containerHolder = [];

  E2eTestSetup(this.repositoryRoot, this.dockerFile, this.dockerTag);

  E2eContainer get container => _containerHolder.last;

  factory E2eTestSetup.create() {
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
    return E2eTestSetup(repositoryRoot, dockerFile, dockerTag);
  }

  Future<void> buildImages() async {
    await (_baseDockerBuildFuture ??= Process.run('docker', [
      'build',
      '--tag',
      'stax-e2e-test:latest',
      repositoryRoot,
    ]));
    await Process.run('docker', [
      'build',
      '--file',
      dockerFile,
      '--tag',
      dockerTag,
      '.',
    ]);
  }

  Future<void> setUp() async {
    _containerHolder.add(
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
  }

  Future<void> tearDown() async {
    await Process.run('docker', [
      'rm',
      '--force',
      _containerHolder.removeLast().id,
    ]);
  }
}
