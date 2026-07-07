import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'docker_api_exception.dart';
import 'http_response_head.dart';

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
    for (int i = 0; i <= haystack.length - needle.length; i++) {
      for (int j = 0; j < needle.length; j++) {
        if (haystack[i + j] != needle[j]) continue outer;
      }
      return i;
    }
    return -1;
  }
}
