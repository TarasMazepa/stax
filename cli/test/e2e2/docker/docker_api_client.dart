import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'docker_connection.dart';
import 'interactive_stax_session.dart';

class DockerApiException implements Exception {
  final String message;
  DockerApiException(this.message);
  @override
  String toString() => 'DockerApiException: $message';
}

class DockerApiClient {
  Future<String> createExec(String containerId, List<String> cmd) async {
    final conn = await DockerConnection.connect();
    try {
      final reader = HttpResponseReader(conn.incoming);
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
        throw DockerApiException(
          'exec create failed (${head.statusCode}): ${utf8.decode(detail)}',
        );
      }
      final json =
          jsonDecode(utf8.decode(await reader.readBody(head)))
              as Map<String, dynamic>;
      final id = json['Id'];
      if (id is! String) {
        throw DockerApiException('exec create returned no Id: $json');
      }
      return id;
    } finally {
      await conn.close();
    }
  }

  Future<InteractiveStaxSession> startExec(String execId) async {
    final conn = await DockerConnection.connect();
    try {
      final reader = HttpResponseReader(conn.incoming);
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
        throw DockerApiException(
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
      await conn.close();
      rethrow;
    }
  }

  Future<int?> inspectExecExitCode(String execId) async {
    final conn = await DockerConnection.connect();
    try {
      final reader = HttpResponseReader(conn.incoming);
      conn.add(_buildRequest('GET', '/exec/$execId/json'));
      await conn.flush();

      final head = await reader.readHead();
      if (head.statusCode != 200) {
        throw DockerApiException('exec inspect failed (${head.statusCode})');
      }
      final json =
          jsonDecode(utf8.decode(await reader.readBody(head)))
              as Map<String, dynamic>;
      if (json['Running'] == true) return null;
      final code = json['ExitCode'];
      return code is int ? code : null;
    } finally {
      await conn.close();
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

@visibleForTesting
class HttpResponseHead {
  final int statusCode;
  final Map<String, String> headers; // lower-cased keys

  HttpResponseHead(this.statusCode, this.headers);

  int? get contentLength {
    final v = headers['content-length'];
    return v == null ? null : int.tryParse(v.trim());
  }

  bool get isChunked =>
      (headers['transfer-encoding'] ?? '').toLowerCase().contains('chunked');
}

@visibleForTesting
class HttpResponseReader {
  final List<int> _buffer = [];
  final _released = StreamController<List<int>>();
  bool _releasing = false;
  bool _done = false;
  Object? _error;
  Completer<void>? _dataSignal;

  HttpResponseReader(Stream<List<int>> source) {
    source.listen(
      (chunk) {
        if (_releasing) {
          _released.add(chunk);
        } else {
          _buffer.addAll(chunk);
          _signal();
        }
      },
      onError: (Object e, StackTrace st) {
        if (_releasing) {
          _released.addError(e, st);
        } else {
          _error = e;
          _done = true;
          _signal();
        }
      },
      onDone: () {
        if (_releasing) {
          unawaited(_released.close());
        } else {
          _done = true;
          _signal();
        }
      },
    );
  }

  void _signal() {
    _dataSignal?.complete();
    _dataSignal = null;
  }

  Future<void> _waitForData() {
    if (_buffer.isNotEmpty || _done) return Future.value();
    return (_dataSignal ??= Completer<void>()).future;
  }

  /// Reads and parses the status line and headers (up to CRLFCRLF).
  Future<HttpResponseHead> readHead() async {
    const terminator = [13, 10, 13, 10];
    while (true) {
      final idx = _indexOf(_buffer, terminator);
      if (idx != -1) {
        final headEnd = idx + terminator.length;
        final headText = String.fromCharCodes(_buffer.sublist(0, headEnd));
        _buffer.removeRange(0, headEnd);
        return _parseHead(headText);
      }
      if (_done) {
        if (_error != null) throw _error!;
        throw DockerApiException('Connection closed before HTTP headers');
      }
      await _waitForData();
    }
  }

  Future<List<int>> readBody(HttpResponseHead head) async {
    final len = head.contentLength;
    if (len != null) return _readExactly(len);
    if (head.isChunked) return _readChunked();
    return _readToEnd();
  }

  Future<List<int>> _readExactly(int n) async {
    while (_buffer.length < n) {
      if (_done) {
        if (_error != null) throw _error!;
        throw DockerApiException('Connection closed before $n body bytes');
      }
      await _waitForData();
    }
    final out = _buffer.sublist(0, n);
    _buffer.removeRange(0, n);
    return out;
  }

  Future<List<int>> _readToEnd() async {
    while (!_done) {
      await _waitForData();
    }
    if (_error != null) throw _error!;
    final out = List<int>.from(_buffer);
    _buffer.clear();
    return out;
  }

  Future<List<int>> _readChunked() async {
    final out = <int>[];
    while (true) {
      final line = await _readLine();
      final size = int.parse(line.split(';').first.trim(), radix: 16);
      if (size == 0) {
        await _readLine(); // trailing CRLF
        return out;
      }
      out.addAll(await _readExactly(size));
      await _readLine(); // CRLF after chunk
    }
  }

  Future<String> _readLine() async {
    const crlf = [13, 10];
    while (true) {
      final idx = _indexOf(_buffer, crlf);
      if (idx != -1) {
        final line = String.fromCharCodes(_buffer.sublist(0, idx));
        _buffer.removeRange(0, idx + crlf.length);
        return line;
      }
      if (_done) {
        if (_error != null) throw _error!;
        throw DockerApiException('Connection closed mid-line');
      }
      await _waitForData();
    }
  }

  Stream<List<int>> releaseRawStream() {
    if (_buffer.isNotEmpty) {
      _released.add(Uint8List.fromList(_buffer));
      _buffer.clear();
    }
    if (_done) {
      if (_error != null) {
        _released.addError(_error!);
      }
      unawaited(_released.close());
    }
    _releasing = true;
    return _released.stream;
  }

  static HttpResponseHead _parseHead(String headText) {
    final lines = const LineSplitter().convert(headText);
    final statusParts = lines.first.split(' ');
    final statusCode = statusParts.length >= 2
        ? int.tryParse(statusParts[1]) ?? 0
        : 0;
    final headers = <String, String>{};
    for (final line in lines.skip(1)) {
      if (line.isEmpty) continue;
      final sep = line.indexOf(':');
      if (sep == -1) continue;
      headers[line.substring(0, sep).trim().toLowerCase()] = line
          .substring(sep + 1)
          .trim();
    }
    return HttpResponseHead(statusCode, headers);
  }

  static int _indexOf(List<int> haystack, List<int> needle) {
    outer:
    for (var i = 0; i <= haystack.length - needle.length; i++) {
      for (var j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) continue outer;
      }
      return i;
    }
    return -1;
  }
}
