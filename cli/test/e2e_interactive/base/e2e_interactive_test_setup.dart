import 'dart:io';

import '../docker/docker_api_client.dart';
import '../docker/interactive_stax_session.dart';
import '../../test_file_original_path.dart';

class E2eInteractiveTestSetup {
  final String repositoryRoot;
  final String dockerFile;
  final String dockerTag;
  final List<String> _containerIds = [];
  final DockerApiClient _docker = DockerApiClient();

  E2eInteractiveTestSetup(this.repositoryRoot, this.dockerFile, this.dockerTag);

  String get containerId => _containerIds.last;

  Future<ProcessResult> run(String command, [List<String>? args]) {
    return Process.run('docker', ['exec', containerId, command, ...?args]);
  }

  Future<ProcessResult> runStax([List<String>? args]) {
    return run('stax', args);
  }

  Future<InteractiveStaxSession> startInteractive(
    String command, [
    List<String>? args,
  ]) async {
    return _docker.startExec(
      await _docker.createExec(containerId, [command, ...?args]),
    );
  }

  Future<InteractiveStaxSession> startStaxInteractive([List<String>? args]) {
    return startInteractive('stax', args);
  }

  factory E2eInteractiveTestSetup.create() {
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
    return E2eInteractiveTestSetup(repositoryRoot, dockerFile, dockerTag);
  }

  Future<void> buildImages() async {
    final result = await Process.run('docker', [
      'build',
      '--tag',
      'stax-e2e-test:latest',
      repositoryRoot,
    ]);

    print('ExitCode: ${result.exitCode}');
    print('STDOUT:\n${result.stdout}');
    print('STDERR:\n${result.stderr}');

    if (result.exitCode != 0) {
      throw Exception('Docker build failed');
    }

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
    _containerIds.add(
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
    );
  }

  Future<void> tearDown() async {
    await Process.run('docker', ['rm', '--force', _containerIds.removeLast()]);
  }
}
