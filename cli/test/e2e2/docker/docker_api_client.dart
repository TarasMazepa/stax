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
      throw Exception(
        'Failed to connect to $path: ${e.message}',
      );
    }
  }

  Future<String> createExec(String containerId, List<String> cmd) async {
    final conn = await _connect();
    try {
      final reader = HttpResponseReader(conn);
      final body = jsonEncode({
        'AttachStdin': true,
        'AttachStdout': true,
        'AttachStderr': true,
        'Tty': true,
        'Cmd': cmd,
      });
      conn.add(
        _buildRequest('POST', '/containers/$containerId/exec', jsonBody: body),
      );
      await conn.flush();
      final head = await reader.readHead();
      if (head.statusCode != 201) {
        final detail = await reader.readBody(head);
        throw Exception(
          'exec create failed (${head.statusCode}): ${utf8.decode(detail)}',
        );
      }
      final json =
          jsonDecode(utf8.decode(await reader.readBody(head)))
              as Map<String, dynamic>;
      final id = json['Id'];
      if (id is! String) {
        throw Exception('exec create returned no Id: $json');
      }
      return id;
    } finally {
      await conn.closeSafely();
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
    final conn = await _connect();
    try {
      final reader = HttpResponseReader(conn);
      conn.add(_buildRequest('GET', '/exec/$execId/json'));
      await conn.flush();

      final head = await reader.readHead();
      if (head.statusCode != 200) {
        throw Exception('exec inspect failed (${head.statusCode})');
      }
      final json =
          jsonDecode(utf8.decode(await reader.readBody(head)))
              as Map<String, dynamic>;
      if (json['Running'] == true) return null;
      final code = json['ExitCode'];
      return code is int ? code : null;
    } finally {
      await conn.closeSafely();
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
