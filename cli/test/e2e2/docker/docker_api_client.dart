import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'interactive_stax_session.dart';

extension OnSocket on Socket {
  Future<void> closeSafely() async {
    try {
      await flush();
      await close();
    } finally {
      destroy();
    }
  }
}

class DockerApiClient {
  HttpClient _createDockerClient() {
    if (Platform.isWindows) {
      throw UnsupportedError(
        'Windows is not supported. Docker Engine API is currently implemented for Unix sockets only.',
      );
    }
    const path = '/var/run/docker.sock';
    if (!File(path).existsSync() && !Link(path).existsSync()) {
      throw Exception(
        'Docker socket not found at $path. Is the Docker daemon running?',
      );
    }
    return HttpClient()
      ..connectionFactory = (Uri uri, String? proxyHost, int? proxyPort) {
        return Socket.startConnect(
          InternetAddress(path, type: InternetAddressType.unix),
          0,
        );
      };
  }


  Future<String> createExec(String containerId, List<String> cmd) async {
    final client = _createDockerClient();
    try {
      final request = await client.postUrl(
        Uri.parse('http://docker/containers/$containerId/exec'),
      );
      request.headers.contentType = ContentType.json;
      request.write(
        jsonEncode({
          'AttachStdin': true,
          'AttachStdout': true,
          'AttachStderr': true,
          'Tty': true,
          'Cmd': cmd,
        }),
      );
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 201) {
        throw Exception(
          'exec create failed (${response.statusCode}): $body',
        );
      }
      if (jsonDecode(body) case {'Id': String id}) return id;
      throw Exception('exec create returned no Id: $body');
    } finally {
      client.close();
    }
  }

  Future<InteractiveStaxSession> startExec(String execId) async {
    final client = _createDockerClient();
    try {
      final request = await client.postUrl(
        Uri.parse('http://docker/exec/$execId/start'),
      );
      request.headers.add('Connection', 'Upgrade');
      request.headers.add('Upgrade', 'tcp');
      request.headers.contentType = ContentType.json;
      request.write(
        jsonEncode({'Detach': false, 'Tty': true}),
      );
      final response = await request.close();

      if (response.statusCode != 101 && response.statusCode != 200) {
        final body = await response.transform(utf8.decoder).join();
        throw Exception(
          'exec start failed (${response.statusCode}): $body',
        );
      }
      final socket = await response.detachSocket();
      return InteractiveStaxSession(
        this,
        execId,
        socket,
        socket,
      );
    } catch (_) {
      client.close();
      rethrow;
    }
  }

  Future<int?> inspectExecExitCode(String execId) async {
    final client = _createDockerClient();
    try {
      final request = await client.getUrl(
        Uri.parse('http://docker/exec/$execId/json'),
      );
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) {
        throw Exception('exec inspect failed (${response.statusCode})');
      }
      final json = jsonDecode(body);
      if (json case {'Running': true}) return null;
      if (json case {'ExitCode': int code}) return code;
      return null;
    } finally {
      client.close();
    }
  }


}
