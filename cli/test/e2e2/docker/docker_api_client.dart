import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'http_response_reader.dart';
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

  Future<Socket> _connect() async {
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
    try {
      return await Socket.connect(
        InternetAddress(path, type: InternetAddressType.unix),
        0,
      );
    } on SocketException catch (e) {
      throw Exception('Failed to connect to $path: ${e.message}');
    }
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
        throw Exception('exec create failed (${response.statusCode}): $body');
      }
      final json = jsonDecode(body) as Map<String, dynamic>;
      final id = json['Id'];
      if (id is! String) {
        throw Exception('exec create returned no Id: $json');
      }
      return id;
    } finally {
      client.close();
    }
  }

  Future<InteractiveStaxSession> startExec(String execId) async {
    final conn = await _connect();
    try {
      final reader = HttpResponseReader(conn);
      conn.add(
        _buildRequest(
          'POST',
          '/exec/$execId/start',
          headers: const {'Connection': 'Upgrade', 'Upgrade': 'tcp'},
          jsonBody: jsonEncode({'Detach': false, 'Tty': true}),
        ),
      );
      await conn.flush();

      final head = await reader.readHead();
      if (head.statusCode != 101 && head.statusCode != 200) {
        final detail = await reader.readBody(head);
        throw Exception(
          'exec start failed (${head.statusCode}): ${utf8.decode(detail)}',
        );
      }
      return InteractiveStaxSession(
        this,
        execId,
        conn,
        reader.releaseRawStream(),
      );
    } catch (_) {
      await conn.closeSafely();
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
      final json = jsonDecode(body) as Map<String, dynamic>;
      if (json['Running'] == true) return null;
      final code = json['ExitCode'];
      return code is int ? code : null;
    } finally {
      client.close();
    }
  }

  static List<int> _buildRequest(
    String method,
    String path, {
    Map<String, String> headers = const {},
    String? jsonBody,
  }) {
    final sb = StringBuffer()
      ..write('$method $path HTTP/1.1\r\n')
      ..write('Host: docker\r\n');
    headers.forEach((k, v) => sb.write('$k: $v\r\n'));
    final bodyBytes = jsonBody == null ? const <int>[] : utf8.encode(jsonBody);
    if (jsonBody != null) {
      sb
        ..write('Content-Type: application/json\r\n')
        ..write('Content-Length: ${bodyBytes.length}\r\n');
    }
    sb.write('\r\n');
    return [...utf8.encode(sb.toString()), ...bodyBytes];
  }
}
