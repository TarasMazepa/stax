import 'dart:io';

import '../../e2e2/docker/docker_api_client.dart';
import '../../e2e2/docker/interactive_stax_session.dart';

class E2e2Container {
  final String id;
  final DockerApiClient _docker = DockerApiClient();

  E2e2Container(this.id);

  Future<ProcessResult> exec(List<String> cmd) {
    return Process.run('docker', ['exec', id, ...cmd]);
  }

  Future<ProcessResult> stax(List<String> args) {
    return exec(['stax', ...args]);
  }

  Future<InteractiveStaxSession> execInteractive(List<String> cmd) async {
    final execId = await _docker.createExec(id, cmd);

    final session = await _docker.startExec(execId);
    return session;
  }

  Future<InteractiveStaxSession> staxInteractive(List<String> args) {
    return execInteractive(['stax', ...args]);
  }
}
