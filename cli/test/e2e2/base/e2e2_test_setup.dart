import 'dart:io';

import '../../e2e2/docker/docker_api_client.dart';
import '../../e2e2/docker/interactive_stax_session.dart';
import '../../test_file_original_path.dart';

class E2e2TestSetup {
  final String repositoryRoot;
  final String dockerFile;
  final String dockerTag;
  final List<String> _containerIds = [];
  final DockerApiClient _docker = DockerApiClient();

  E2e2TestSetup(this.repositoryRoot, this.dockerFile, this.dockerTag);

  String get containerId => _containerIds.last;

  Future<ProcessResult> exec(List<String> cmd) {
    return Process.run('docker', ['exec', containerId, ...cmd]);
  }

  Future<ProcessResult> stax(List<String> args) {
    return exec(['stax', ...args]);
  }

  Future<InteractiveStaxSession> execInteractive(List<String> cmd) async {
    return _docker.startExec(await _docker.createExec(containerId, cmd));
  }

  Future<InteractiveStaxSession> staxInteractive(List<String> args) {
    return execInteractive(['stax', ...args]);
  }

  factory E2e2TestSetup.create() {
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
    return E2e2TestSetup(repositoryRoot, dockerFile, dockerTag);
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
